---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第三章：Linux服务器系统管理基础

---

## System Administrator is root

# Linux服务器管理员的典型工作场景和需求

---

* 本地工作用电脑是Windows或Mac，Linux是远程服务器系统
* 服务器7x24小时开机，除去系统内核更新等需要重启服务器的情况
* 远程SSH登录到服务器上是工作常态
* 移动办公时可以保持远程服务器上的操作被“记住”和“按需复原”
* 让进程更优雅的运行在后台，退出SSH会话不影响刚才启动的进程

# 远程管理工具箱

---

* 工作电脑
    * SSH客户端软件
    * [Visual Studio Code Remote - SSH](https://code.visualstudio.com/docs/remote/ssh)
* 服务器上
    * tmux（[screen](https://www.gnu.org/software/screen/)的增强版）

---

## [Visual Studio Code Remote - SSH](https://code.visualstudio.com/docs/remote/ssh)

![](images/ansible/architecture-ssh.png)

---

### [系统依赖条件](https://code.visualstudio.com/docs/remote/ssh#_getting-started) {id="system-requirements"}

* 工作主机依赖条件
    * SSH 客户端软件
        * **Windows 平台** `推荐但可选` `git-bash`
* 远程主机依赖条件
    * 开启 `SSH 服务` 的当前主流 Linux 发行版本
        * [远程主机可以访问互联网](https://code.visualstudio.com/docs/remote/faq#_what-are-the-connectivity-requirements-for-vs-code-server)

---

### Windows 平台安装与配置 {id="setup-vscode-remote-on-win-1"}

* `VSCode` 扩展应用商店安装 [Remote Development Extenstion Pack](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack)
* （推荐但可选）配置 SSH 免密登录远程主机
    * 使用 `git-bash` 配置 SSH 免密登录

---

### 使用 `git-bash` 配置 SSH 免密登录

1. 添加新的 `SSH Targets`
2. 打开 `git bash` ，输入以下指令完成 `git bash` SSH 免密登录
3. 在选择 `SSH 配置文件` 时，选择当前用户 `家目录` 下 `.ssh/config` 用于保存远程主机配置信息
4. 在 `VSCode` 里连接新添加的远程 SSH 主机

```bash
# 检查是否已经生成过 SSH 公私钥对 id_rsa.pub 和 id_rsa
ls ~/.ssh/

# 如果没有上述 2 个文件时
# 生成 RSA 算法 4096 位秘钥长度的 SSH 公私钥对
# 否则，跳过当前步骤
ssh-keygen -t rsa -b 4096

# 配置免密登录
# 假设远程主机的连接信息为 cuc@192.168.56.161
ssh-copy-id -i ~/.ssh/id_rsa.pub cuc@192.168.56.161

# 连接验证免密登录配置成功
ssh cuc@192.168.56.161
```

---

### 配置示例截图

![](images/chap0x03/vscode-remote.png)

---

### 已知缺陷 {id="known-issues"}

* 快捷键绑定冲突
    * `CTRL-F` 在 `Windows` 平台的 `VSCode` 里是默认绑定的「打开搜索对话框」快捷键，与 `vim` 注册快捷键冲突
* 远程 Linux 主机上会启动一个 `node` 服务进程用于响应本地 `VSCode` 的远程编辑与管理任务
    * `100MB+` 内存占用，对于小内存 Linux 系统来说是一个不小的负担

```bash
# 验证 vscode 远程服务进程的内存占用率
ps -o pid,user,%mem,command ax | sort -b -k3 -r | head
```

---

## tmux

```bash
# 开启一个tmux会话
tmux
# CTRL-B d 脱离(detach)当前tmux会话
# 再开启一个tmux会话
tmux
# CTRL-B d 再脱离(detach)当前tmux会话
# 查看当前可用的tmux会话列表
tmux ls
# 连接到会话编号0的会话
tmux attach -t 0
# 退出并关闭当前会话
exit
```

---

用tmux重做上一章的ping前后台执行方式实验


```bash
# 本实验建议通过SSH远程登录到虚拟机上执行
ping www.baidu.com 2>&1 1>/dev/null &
ping www.cuc.edu.cn 2>&1 1>/dev/null &
# 注意查看输出结果，观察ping进程的父进程是谁
pstree -A
# 此时退出SSH登录
exit
# 再重新SSH登录到虚拟机上执行
# 注意查看输出结果，观察ping进程的父进程是谁，和退出SSH登录之前相比是否有变化？
pstree -A
# 开启一个tmux会话
tmux
# 重复上述实验，用后台进程方式开启新的ping进程
# 再次SSH登录到虚拟机上执行
# 注意查看输出结果，观察ping进程的父进程是谁，和退出SSH登录之前相比是否有变化？
pstree -A
```

# 用户/组与权限管理

---

* su与sudo
    * visudo
* passwd
* adduser/useradd
* groupadd/addgroup
* usermod
* getfacl/setfacl

---

## 用户标识（uid）

```bash
id --help
id
id -g
id -u
```

* 上述后2个命令的参数作用是什么？
* 什么是**effective group ID**？
* 什么是**effective user ID**？

---

## 查看和理解文件和目录的属主与权限

从🌰开始

```bash
$ ls -ld /tmp
drwxrwxrwt 8 root root 4096 Jan 20 15:26 /tmp

$ ls -l /usr/bin/passwd
-rwsr-xr-x 1 root root 54256 Mar 29  2016 /usr/bin/passwd

$ ls -l /etc/shadow
-rw-r----- 1 root shadow 941 Jan 16 12:37 /etc/shadow
```

---

问题来了：

* rwx我们知道对应“读”、“写”、“执行”权限位标识，这里出现的**d**、**t**、**s**是什么情况？
* 普通用户为什么可以使用**/usr/bin/passwd**去更改自己的密码（修改**/etc/shadow**文件）？

---

### 文件类型

> [FreeBSD 的 man 手册页 ls 摘录](https://www.freebsd.org/cgi/man.cgi?query=ls&apropos=0&sektion=0&manpath=FreeBSD+11.1-RELEASE+and+Ports&arch=default&format=html)

* b  &emsp;&emsp;块特殊文件（Block special file）
* c  &emsp;&emsp;字符特殊文件（Character special file）
* d  &emsp;&emsp;目录（Directory）
* l  &emsp;&emsp;符号链接（Symbolic link）
* s  &emsp;&emsp;套接字链接（Socket link）
* p  &emsp;&emsp;命名管道（FIFO）
* \- &emsp;&emsp;普通文件（Regular file）

---

## Saved UID (SUID) 

* 对应属主用户列权限位中的**s**标记，取代原有显示**x**标记的位置
* 当且仅当一个文件是二进制可执行文件（脚本文件即使设置了“可执行”也不行）时可以被设置SUID
* 一个被设置了SUID的程序，其他用户执行该程序时就会“暂时”得到文件拥有者（通常是root）的权限

---

## Saved GID (SGID)

* 对应属主用户组列权限位中的**s**标记，取代原有显示**x**标记的位置
* 如果SGID设置在二进制**文件**上，则不论用户是谁，在执行该程序的时候，它的有效用户组（effective group）将会变成该程序的用户组所有者（group id）
* 如果SGID是设置在A**目录**上，则在该A**目录**内所建立的文件或目录的用户组，将强制被设置为此A目录的用户组

---

## Sticky Bit

* 对应**t**标记，取代原有显示**x**标记的位置
* 只能设置在目录上，对文件没有效果
* 在被设置了**t**标记的目录下，用户若在该目录下具有w及x权限，则当用户在该目录下建立文件或目录时，只有文件属主与root才有权限删除

---

## 关于 SUID 和 SGID 的实践验证 🌰 {id='suid-sgid-exp'}

[![asciicast](https://asciinema.org/a/ClSacEE7TQCBt6PSvAK23iXuf.svg)](https://asciinema.org/a/ClSacEE7TQCBt6PSvAK23iXuf)

---

## 改变文件和目录的属主与权限

* chown
* chgrp
* chmod
* umask

```bash
# 设置SUID
chmod 4755 filename

# 设置SGID
chmod 2755 dirname

# 同时设置SUID和SGID（罕见）
chmod 6755 filename

# 设置Sticky Bit
chmod 1755 dirname
```

# sudo 的一些坑

---

## shell 内部命令无法 sudo

```bash
cmds=(echo cd history getopts kill pwd); for cmd in "${cmds[@]}";do type -a "$cmd";done
# echo is a shell builtin
# echo is /usr/bin/echo
# echo is /bin/echo
# cd is a shell builtin
# history is a shell builtin
# getopts is a shell builtin
# kill is a shell builtin
# kill is /usr/bin/kill
# kill is /bin/kill
# pwd is a shell builtin
# pwd is /usr/bin/pwd
# pwd is /bin/pwd
```

---

## 以下场景不要 sudo

* 编辑用户家目录下的文件
* 源代码编译
* 针对 Mac 用户
    * <del>sudo brew install</del>
    * <del>sudo pip install</del>

# 文件系统与存储管理

---

* 文件系统格式
    * ext3 / ext4 / swap
    * mkfs
* 文件分区
    * 分区原则与策略
    * fdisk / gdisk
    * 大于2TB分区支持使用 [parted](https://www.cyberciti.biz/tips/fdisk-unable-to-create-partition-greater-2tb.html)
* 文件系统挂载
    * U盘 / NFS / iso / 光盘
    * /etc/fstab

---

## 常规磁盘管理步骤

```bash
# 0. 使用管理员权限
sudo su -

# 1. 选择物理磁盘
lsblk

# 2. 创建分区 
fdisk {{/dev/sdX}}

# 3. 在指定分区上创建文件系统 
# 通过 Shell 「自动补全」功能查看当前支持的文件系统类型
# mkfs.<TAB><TAB>
mkfs -t {{ext4}} {{path/to/partition}}

# 4. 将分区挂载到指定目录 
mount -t {{filesystem_type}} {{path/to/device_file}} {{path/to/target_directory}}
```

---

## [逻辑卷管理](https://wiki.archlinux.org/index.php/LVM_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\)) - [LVM, Logical Volume Management](https://wiki.ubuntu.com/Lvm)

* LVM 是一种可用在Linux内核的逻辑分卷管理器；可用于管理磁盘驱动器或其他类似的大容量存储设备

LVM利用Linux内核的device-mapper来实现存储系统的虚拟化（系统分区独立于底层硬件）。 通过LVM，你可以实现存储空间的抽象化并在上面建立虚拟分区（virtual partitions），可以更简便地扩大和缩小分区，可以增删分区时无需担心某个硬盘上没有足够的连续空间，LVM是用来方便管理的，**不会提供额外的安全保证**。

> [配合存储硬件的Raid技术，提供高可靠性](https://www.ibm.com/developerworks/cn/linux/l-cn-pclvm-rstr/)

---

## LVM 的基本组成块（building blocks）

* 物理卷(PV, Physical Volume )：可以在上面建立卷组的媒介，可以是硬盘分区，也可以是硬盘本身或者回环文件（loopback file）。物理卷包括一个特殊的header，其余部分被切割为一块块物理区域（physical extents）。基于物理卷可以创建“逻辑上或虚拟的”硬盘。 
* 卷组(VG, Volume Group)：将一组物理卷收集为一个管理单元。一个卷组就相当于一个“物理”硬盘。
* 逻辑卷(LV, Logical Volume)：虚拟分区，由物理区域（physical extents）组成。相当于基于“物理”硬盘（卷组）之上的文件系统分区。
* 物理区域(PE, Physical Extent)：硬盘可供指派给逻辑卷的最小单位（通常为4MB）。

---

## 基于 LVM 的磁盘管理体系结构 {id="lvm-arch"}

[![](images/chap0x03/lvm-arch.png)](images/chap0x03/lvm-arch.svg)

---

## 基于 LVM 的磁盘管理步骤 {id="lvm-based-partitions"}

```bash
# 0. 使用管理员权限
sudo su -

# 1. 选择物理磁盘
lsblk

# 2. 创建分区 
gdisk {{/dev/sdX}}

# 2.1. PV 管理阶段
# 2.1.1. 在物理分区上创建 PV
pvcreate {{/dev/sdX1}}

# 查看所有可用 PV
pvs
pvscan

# 2.2. VG 管理阶段
# 2.2.1. 创建 VG
# 以下例子将 3 个物理分区加入到一个名为 ubuntu-vg 的 VG
vgcreate {{ubuntu-vg}} {{/dev/sda1}} {{/dev/sdb1}} {{/dev/sdc1}}

# 2.2.2. 从指定 VG 中移除一个 PV
vgreduce {{ubuntu-vg}} {{/dev/sdc1}}

# 2.2.3. 将一个 PV 加入到一个指定 VG 中
vgextend {{ubuntu-vg}} {{/dev/sda5}}

# 查看 VG 详细信息
vgdisplay

# 2.3. LV 阶段
# -L 指定分区大小，-n 指定逻辑分区名称
lvcreate -L 10G -n {{demo-lv}} {{ubuntu-vg}}
lvcreate -l {{100%FREE}} -n {{demo-lv}} {{ubuntu-vg}}

# 查看 LV 详细信息
lvdisplay
# --- Logical volume ---
#   LV Path                /dev/ubuntu-vg/demo-lv
#   LV Name                demo-lv
#   VG Name                ubuntu-vg
#   LV UUID                FKJDB5-KJkj-aIp1-t5BR-lp1w-68Yb-BVor5k
#   LV Write Access        read/write
#   LV Creation host, time cuc-lab, 2021-03-19 13:36:21 +0000
#   LV Status              available
#   # open                 0
#   LV Size                <29.50 GiB
#   Current LE             7551
#   Segments               1
#   Allocation             inherit
#   Read ahead sectors     auto
#   - currently set to     256
#   Block device           253:1

# 3. 在指定分区上创建文件系统 
# 通过 Shell 「自动补全」功能查看当前支持的文件系统类型
# mkfs.<TAB><TAB>
# 此处 {{path/to/partition}} 对应 lvdisplay 输出信息里的 LV Path 字段值
mkfs -t {{ext4}} {{path/to/partition}}

# 4. 将分区挂载到指定目录 
mkdir -p {{path/to/target_directory}}
mount -t {{filesystem_type}} {{path/to/device_file}} {{path/to/target_directory}}

# 5. 调整分区大小
# 5.1. 卸载指定 LVM 分区
umount {{path/to/device_file}}

# 5.2. 检查 ext2/ext3/ext4 分区是否有损坏
e2fsck -f {{path/to/device_file}}

# 5.3. 分区扩容
lvresize --size +{{120G}} --resizefs {{volume_group}}/{{logical_volume}}
lvresize --size {{100}}%FREE {{volume_group}}/{{logical_volume}}

# 5.4. 分区缩减（可能会由于缩减后存储容量不足导致数据丢失）
lvresize --size -{{120G}} --resizefs {{volume_group}}/{{logical_volume}}
```

---

### LVM 优点(1/2) {id="lvm-advantages-1"}

* 比起正常的硬盘分区管理，LVM更富于弹性：
* 使用卷组，使众多硬盘空间看起来像一个大硬盘。
* 使用逻辑卷，可以创建跨越众多硬盘空间的分区。
* 可以创建小的逻辑卷，在空间不足时再动态调整它的大小。
* 在调整逻辑卷大小时可以不用考虑逻辑卷在硬盘上的位置，不用担心没有可用的连续空间。
* 可以在线对逻辑卷和卷组进行创建、删除、调整大小等操作。LVM上的文件系统也需要重新调整大小，某些文件系统也支持这样的在线操作。

---

### LVM 优点(2/2) {id="lvm-advantages-2"}

* 无需重新启动服务，就可以将服务中用到的逻辑卷在线/动态迁移至别的硬盘上。
* 允许创建快照，可以保存文件系统的备份，同时使服务的下线时间（downtime）降低到最小。

这些优点使得LVM对服务器的管理非常有用，对于桌面系统管理的帮助则没有那么显著，你需要根据实际情况进行取舍。


---

### LVM 缺点 {id="lvm-shortcomings"}

* 在系统设置时需要更复杂的额外步骤
* LVM 配置丢失或损坏时，数据恢复难度较高

# 文件备份 - 文件打包

---

* 大部分的Linux压缩工具遵循 `KISS(Keep It Simple and Stupid)原则` ，即“**每个程序只做一件事，不要试图在单个程序中完成多个任务**”，所以压缩工具只是被设计用来对单个文件进行压缩，如果要对很多文件、一个目录下所有子目录和文件进行压缩，则需要先使用**打包工具**对批量的文件和目录进行打包，变成一个文件之后，再将压缩任务交给专门的压缩工具软件。

# 文件备份 - 文件归档

---

* 连同所有目录、文件的**属主信息**、**时间戳信息**一并**打包**保存
* 妥善处理ln创建的链接文件（保留原有的目标指向信息），避免重复备份
* [BackupYourSystem/TAR from ubuntu official documentation](https://help.ubuntu.com/community/BackupYourSystem/TAR)
* [Full system backup with rsync](https://wiki.archlinux.org/index.php/full_system_backup_with_rsync)
    * 增量备份

# 文件恢复

---

* 在**系统正常时**要***定期测试备份文件是否可以正常恢复和还原***
    * [2017年2月1日GitLab.com数据库被误删事件的官方通告](https://about.gitlab.com/2017/02/01/gitlab-dot-com-database-incident/)
* 恢复前记得先备份当前目标目录和文件，避免错误、不可逆的文件覆盖
* 恢复前检查备份文件完整性（使用签名、散列值校验等）

# 系统备份

---

## 备份策略设计约束性因素 {id="how-to-backup-1"}

* 可移植性（便携性）：是否需要考虑跨OS的数据备份与恢复，如果是，则可以试试**dd**、**tar**、**cpio**等命令行工具
* 无人值守（自动备份）
* 用户友好：非专业用户首选交互设计良好的备份恢复工具
* 远程备份：首选CLI方式的备份恢复工具

---

## 备份策略设计约束性因素 {id="how-to-backup-2"}

* 网络备份：首选支持网络存储系统读写的备份恢复工具，如tar
* 存储介质：成本、可靠性、存储容量和传输性能
* 可审计：所有数据的备份方案，备份频率如何，备份数据放在哪里，保留多久等优先使用代码进行定义，而不是文档。备份策略的变更可以通过代码变更记录进行审计，对于违反备份策略、可能会引起备份或恢复失败的变更要能阻止变更（代码提交合并）

---

## 系统备份与恢复

* 如果系统被评估为遭受了入侵，建议备份好重要数据之后，彻底重装系统
* 基于文件备份和恢复机制
* 使用专用的磁盘和文件系统级别的备份和恢复解决方案

# 开机自启动项管理

---

* [SysVinit](https://en.wikipedia.org/wiki/Init) | [LSBInitScripts](https://wiki.debian.org/LSBInitScripts) | [OpenRC: Gentoo独有的系统服务启动控制机制](https://wiki.gentoo.org/wiki/OpenRC)
    * /etc/init.d
* [Upstart: Ubuntu（曾经）团队开发的系统服务启动控制机制](http://upstart.ubuntu.com/)
    * /usr/share/upstart
* [Systemd](https://www.freedesktop.org/wiki/Software/systemd/)
    * /usr/lib/systemd

---

## Systemd - 目前主流发行版支持情况

![](images/chap0x03/systemd-adoption.png)

---

## Systemd - 特性（优点）

* 提供了积极的（服务、进程）并行化启动能力
* 使用socket 和 D-Bus 机制来激活启动服务
* 提供了按需启动守护进程能力
* 实现了基于事务风格依赖管理的服务控制逻辑
* 使用Linux的cgroup机制管理进程
* 支持快照和还原
* 维护挂载和自动挂载点

---

## Systemd - 争议

* 激进的设计
    * 重新发明了一堆历史悠久的核心服务(syslog, ntp, cron, fstab, dhcpcd等等)，虽然是简化功能和配置，但有经验的系统管理员更信赖他们熟悉的服务（尽管配置较为复杂）
    * 作为系统的1号进程，承载的功能太多：单点故障风险集中、不符合UNIX设计哲学 `KISS`
    * 不遵循 POSIX 标准，无法移植到Linux之外的平台
* 过快的开发迭代
    * 代码质量不高
    * 不考虑向后兼容
    * 频繁变更设计和接口

---

## Systemd - 架构

![](images/chap0x03/Systemd_components.svg.png)

# 动手实战Systemd

---

* [Systemd 入门教程：命令篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
* [Systemd 入门教程：实战篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

# [NetPlan](https://netplan.io/)

---

## 又一个「网络配置管理」工具

设计用于「替代」经典 Linux 网络管理工具 [ifupdown](http://manpages.ubuntu.com/manpages/xenial/man5/interfaces.5.html)

![](images/chap0x03/netplan_design_overview.png)

---

## 哪些发行版本在用

* [Ubuntu 17.10](https://blog.ubuntu.com/2017/07/10/netplan-by-default-in-17-10) 开始在 Ubuntu 家族所有发行版中默认安装和启用
* 目前其他发行版应用更广泛的还是经典的  [ifupdown](http://manpages.ubuntu.com/manpages/xenial/man5/interfaces.5.html)

---

## 快速上手

* 配置文件路径 `/etc/netplan/*.yaml`
	* `/run/netplan/*.yaml` 
	* `/lib/netplan/*.yaml`
* 测试和应用配置 `netplan apply`
	* 验证 YAML 语法正确性 `yamllint`
* [FAQ](https://netplan.io/faq)

---

## 配置示例

```yaml
# https://netplan.io/examples#using-dhcp-and-static-addressing
# https://netplan.io/reference
# https://github.com/CanonicalLtd/netplan/tree/master/examples
network:
  version: 2
# renderer: NetworkManager
  renderer: networkd
  ethernets:
    enp3s0:
      dhcp4: true 
    enp5s0:
      addresses:
        - 10.10.10.2/24
      match:
        macaddress: 56:2d:d1:8e:62:17
      gateway4: 10.10.10.1
      nameservers:
          search: [mydomain, otherdomain]
          addresses: [10.10.10.1, 1.1.1.1]
```

---

## 新的网卡命名风格

`enp3s0`

* `en` 代表以太网卡
* `p3s0` 代表 PCI 接口的物理位置为 `(3, 0)`, 其中横座标代表 `bus`，纵座标代表 `slot`

---

摘自 [udev/udev-builtin-net_id.c](https://github.com/systemd/systemd/blob/master/src/udev/udev-builtin-net_id.c#L10)

```c
/* http://www.freedesktop.org/wiki/Software/systemd/PredictableNetworkInterfaceNames
 *
 * Two character prefixes based on the type of interface:
 *   en — Ethernet
 *   ib — InfiniBand
 *   sl — serial line IP (slip)
 *   wl — wlan
 *   ww — wwan
 *
 * Type of names:
 *   b<number>                             — BCMA bus core number
 *   c<bus_id>                             — bus id of a grouped CCW or CCW device,
 *                                           with all leading zeros stripped [s390]
 *   o<index>[n<phys_port_name>|d<dev_port>]
 *                                         — on-board device index number
 *   s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         — hotplug slot index number
 *   x<MAC>                                — MAC address
 *   [P<domain>]p<bus>s<slot>[f<function>][n<phys_port_name>|d<dev_port>]
 *                                         — PCI geographical location
 *   [P<domain>]p<bus>s<slot>[f<function>][u<port>][..][c<config>][i<interface>]
 *                                         — USB port number chain
 *   v<slot>                               - VIO slot number (IBM PowerVM)
 *   a<vendor><model>i<instance>           — Platform bus ACPI instance id
 */
```

# 其他过时的知名网络管理工具

---

[net-tools](https://wiki.linuxfoundation.org/networking/net-tools) 已过时，[iproute2](https://wiki.linuxfoundation.org/networking/iproute2) 是现在。

> Most network configuration manuals still refer to ifconfig and route as the primary network configuration tools, but ifconfig is known to behave inadequately in modern network environments. **They should be deprecated**, but most distros still include them.

---

| [过时命令 net-tools ](http://net-tools.sourceforge.net/) | [替代命令 iproute2 ](https://dougvitale.wordpress.com/2011/12/21/deprecated-linux-networking-commands-and-their-replacements/) |
|:---:|:---:|
| arp	| ip n (ip neighbor) |
| ifconfig |	ip a (ip addr), ip link, ip -s (ip -stats) |
| iwconfig	| iw |
| nameif |	ip link, ifrename |
| netstat |	ss |
| netstat -i | ip -s link |
| netstat -r | ip route |
| netstat -g | ip maddr |
| route	| ip r (ip route) |


# 不同发行版的不同网络管理方案流派

---

## 网络管理方案流派

1. ifconfig/route
2. iproute2
3. NetworkManager
4. systemd-networkd
5. netplan

---

## 以 Debian 系发行版为例

| Linux 发行版 | 桌面版 | 服务器版 |
| :------------ | :----- | :------- |
| Ubuntu 22.04  | NetworkManager（默认）<br>netplan 或 systemd-networkd（可选） | netplan（默认）<br>NetworkManager 或 systemd-networkd（可选） |
| Debian 11     | NetworkManager（默认）<br>ifupdown、iproute2 或 systemd-networkd（可选） | ifupdown（默认）<br>iproute2、NetworkManager 或 systemd-networkd（可选） |

# 本章完成后的自查清单

---

* 如何添加一个用户并使其具备sudo执行程序的权限？
* 如何将一个用户添加到一个用户组？
* 如何查看当前系统的分区表和文件系统详细信息？
* 如何实现开机自动挂载Virtualbox的共享目录分区？
* 基于LVM（逻辑分卷管理）的分区如何实现动态扩容和缩减容量？
* 如何通过systemd设置实现在网络连通时运行一个指定脚本，在网络断开时运行另一个脚本？
* 如何通过systemd设置实现一个脚本在任何情况下被杀死之后会立即重新启动？实现***杀不死***？

# 参考文献

---

* [User identifier from WikiPedia](https://en.wikipedia.org/wiki/User_identifier)
* [Ubuntu Policy Manual Chapter 9 - The Operating System](http://people.canonical.com/~cjwatson/ubuntu-policy/policy.html/ch-opersys.html)
* [umask](https://wiki.archlinux.org/index.php/umask)
* [如何评价 2017 年 2 月 1 日 GitLab 数据库被误删？ from 知乎](https://www.zhihu.com/question/55300424)

---

* [Forensics Tools on Linux](http://forensicswiki.org/wiki/Tools)
* [优雅地使用命令行：Tmux 终端复用](http://harttle.com/2015/11/06/tmux-startup.html)
* [Tmux - Linux从业者必备利器](http://cenalulu.github.io/linux/tmux/)
* [Linux Administration Made Easy Chapter 8. Backup and Restore Procedures](http://www.tldp.org/LDP/lame/LAME/linux-admin-made-easy/server-backup.html)
* [BackupYourSystem from ubuntu official documentation](https://help.ubuntu.com/community/BackupYourSystem)
* [Systemd 入门教程：命令篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-commands.html)
* [Systemd 入门教程：实战篇 by 阮一峰的网络日志](http://www.ruanyifeng.com/blog/2016/03/systemd-tutorial-part-two.html)

---

* [systemd on wikipedia](https://en.wikipedia.org/wiki/Systemd)
* [Fedora官网Wiki对Systemd的介绍](https://fedoraproject.org/wiki/Systemd/zh-cn)
* [ArchiLinux官网Wiki对Systemd的介绍](https://wiki.archlinux.org/index.php/systemd_\(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87\))
* [Debian官网Wiki对Systemd的介绍](https://wiki.debian.org/systemd)
* [Ubuntu官网Wiki对Systemd的介绍](https://wiki.ubuntu.com/SystemdForUpstartUsers)
* [systemd 为什么会有那么大的争议？](https://www.zhihu.com/question/25873473)
* [Debian官方对目前主流系统引导机制的优缺点分析讨论](https://wiki.debian.org/Debate/initsystem/)
* [系统启动过程](https://www.freedesktop.org/software/systemd/man/bootup.html)

