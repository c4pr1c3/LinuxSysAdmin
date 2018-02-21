---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第一章：Linux基础（实验）

---

##  GNU is NOT Unix

# 软件环境

---

* Virtualbox
* Ubuntu 16.04 Server 64bit
    * 备选：Ubuntu 14.04 Server 64bit
    * 备选：Ubuntu 16.04 Desktop 64bit

# 实验问题

---

* 如何配置无人值守安装iso并在Virtualbox中完成自动化安装。
* Virtualbox安装完Ubuntu之后新添加的网卡如何实现系统开机自动启用和自动获取IP？
* 如何使用sftp在虚拟机和宿主机之间传输文件？


# 实验报告要求

---

* 使用markdown格式纯文本
* fork[作业仓库 CUCCS/linux](https://github.com/cuccs/linux)并提交作业到自己的仓库
* 每次的实验报告放在自己**私有**子目录下的独立的子目录，目录命名应简洁、清晰
* 实验报告应图文并茂的记录实验过程，证明自己独立完成的实验作业
* 记录自己独立解决的问题和解决办法，并给出问题解决用到的参考资料出处、链接

# 参考文献

---

* [No “eth0” listed in ifconfig -a, only enp0s3 and lo](http://askubuntu.com/questions/704035/no-eth0-listed-in-ifconfig-a-only-enp0s3-and-lo)

# 无人值守安装iso制作过程示例

---

## 实现特性

* 定制一个普通用户名和默认密码
* 定制安装OpenSSH Server
* 安装过程禁止自动联网更新软件包

---

```bash
# 在当前用户目录下创建一个用于挂载iso镜像文件的目录
mkdir loopdir

# 挂载iso镜像文件到该目录
mount -o loop ubuntu-16.04.1-server-amd64.iso loopdir

# 创建一个工作目录用于克隆光盘内容
mkdir cd
 
# 同步光盘内容到目标工作目录
# 一定要注意loopdir后的这个/，cd后面不能有/
rsync -av loopdir/ cd

# 卸载iso镜像
umount loopdir

# 进入目标工作目录
cd cd/

# 编辑Ubuntu安装引导界面增加一个新菜单项入口
vim isolinux/txt.cfg
```

---

添加以下内容到该文件后强制保存退出

```
label autoinstall
  menu label ^Auto Install Ubuntu Server
  kernel /install/vmlinuz
  append  file=/cdrom/preseed/ubuntu-server-autoinstall.seed debian-installer/locale=en_US console-setup/layoutcode=us keyboard-configuration/layoutcode=us console-setup/ask_detect=false localechooser/translation/warn-light=true localechooser/translation/warn-severe=true initrd=/install/initrd.gz root=/dev/ram rw quiet
```

---


* 提前阅读并编辑定制Ubuntu官方提供的示例[preseed.cfg](https://help.ubuntu.com/lts/installation-guide/example-preseed.txt)，并将该文件保存到刚才创建的工作目录``~/cd/preseed/ubuntu-server-autoinstall.seed``
* 修改isolinux/isolinux.cfg，增加内容``timeout 10``（可选，否则需要手动按下ENTER启动安装界面）

```bash

# 重新生成md5sum.txt
cd ~/cd && find . -type f -print0 | xargs -0 md5sum > md5sum.txt

# 封闭改动后的目录到.iso
IMAGE=custom.iso
BUILD=~/cd/

mkisofs -r -V "Custom Ubuntu Install CD" \
            -cache-inodes \
            -J -l -b isolinux/isolinux.bin \
            -c isolinux/boot.cat -no-emul-boot \
            -boot-load-size 4 -boot-info-table \
            -o $IMAGE $BUILD

# 如果目标磁盘之前有数据，则在安装过程中会在分区检测环节出现人机交互对话框需要人工选择
```

---

一个我修改定制好的[ubuntu-server-autoinstall.seed](exp/chap0x01/cd-rom/preseed/ubuntu-server-autoinstall.seed)，请自行和官方示例文件进行比对，自行思考理解和掌握：

* 我做了哪些修改？
* 这些修改的作用是什么？


