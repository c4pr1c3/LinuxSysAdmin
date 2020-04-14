---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 番外：Cloud-Init

---

## 从零到一

> 从裸机（未安装操作系统的物理主机或虚拟机）到安装好基本系统

* 第 1 章

---

## 一生二

> 从基本系统到基本使用

* 第 2 章 ~ 第 3 章

---

## 二生三

> 从基本使用到可编程、可配置

* 第 4 章 ~ 第 7 章

---

## 三生万物

> 从可编程到自动化、智能化

* 第 8 章

---

* `PXE` 和 `无人值守安装镜像` 可以解决 `从零到一` **自动化** 问题
* `ansible` 解决从 `从二到万物` **自动化** 问题

---

* `ansible` 的使用对目标运行环境也有依赖要求
    * Python 解释器
    * SSH 免密登录
* 以 `puppet` 为代表的基于 `agent` 的自动化管理系统方案需要在「基础镜像」中提前安装好对应的 `agent` 并进行运行时环境相关的必要配置

---

> 以上需求可以通过在定制「基础镜像」阶段将上述预装在系统中

---

> 但是，上述做法并不「优雅」。

---

「基础镜像」应该满足以下特性：

* 最大化「可复用」场景：最小化安装系统，只装「最普遍需要」的基础软件

---

考虑以下集群服务器管理的常见需求：

* 新安装的系统需要预先配置不同用户的不同 SSH 免密登录受信任公钥
* 部分新系统需要安装软件A，另一部分新系统需要安装软件B

---

以上需求对应的操作过程均要求 **自动化** 。

---

这就是 `从一到三` 的 **自动化** 问题。

---

> 怎么解决 `从一到三` 的 **自动化** 问题？

---

## Cloud-Init 的作用

> 解决 `从一到三` （从基本系统到可编程、可配置） 的 **自动化** 问题

# 从「第一个 🌰 」开始体验 cloud-init

---

```bash
sudo apt update && sudo apt install cloud-init genisoimage

mkdir -p ~/workspace/cloud-init && cd ~/workspace/cloud-init 

cat << EOF > ~/workspace/cloud-init/meta-data
instance-id: 1
local-hostname: cuc-cloud-init
EOF

cat << EOF > ~/workspace/cloud-init/user-data
#cloud-config
password: mypassword 
chpasswd: { expire: False }
ssh_pwauth: True
EOF

genisoimage -output init-cidata.iso -volid cidata -joliet -rock user-data meta-data
```

---

* 将虚拟机内的 `init-cidata.iso` 下载到宿主机系统
* 在 Virtualbox 的当前虚拟机设置界面挂载 `init-cidata.iso`

![](images/cloud-init/vb-cidata.png)

---

重启 `当前虚拟机` ，登录进入系统后：

```bash
# 系统的主机名变成了上述配置文件示例里的 cuc-cloud-init

# 查看系统中会新多出一个用户 `ubuntu` 
id ubuntu

# 输入上述配置文件示例里设置的口令 `mypassword` 
su ubuntu

# 检查当前用户身份
id
```

# 详解上一个🌰

---

## user-data

```yaml
#cloud-config
```

* 标识当前文件是一个 `cloud-config` 类型文件，这是最常用的一类 `User-Data`

---

```yaml
password: mypassword 
```

`Ubuntu` 发行版默认创建的用户名为 `ubuntu`，此处 `password` 指令等价于先创建新用户 `ubuntu` ，然后设置口令为 `mypassword` 。

* [users 配置关键字定义的列表中第一个用户就是系统的默认用户，如果希望保留发行版默认标准用户名则第一个用户应设置为 default](https://cloudinit.readthedocs.io/en/latest/topics/modules.html#users-and-groups) 。
* 口令格式既可以是明文，也可以是 `mkpasswd` 创建的「哈希后口令」。

---

## 创建「哈希后口令」的🌰

```bash
sudo apt install whois
mkpasswd -m help # 获取当前版本支持的哈希算法
mkpasswd -m sha-512 mypassword
```

---

```yaml
chpasswd: { expire: False }
```

`chpasswd` 用于对系统中 **已有** 用户更改口令或设置口令强制过期策略。支持 `expire` 和 `list` 属性。其中 `list` 关键字支持 `username:password` 列表形式，既可以是 `YAML list` 格式，也可以是「一行一键值对」的 `多行` 字符串。

---

```yaml
ssh_pwauth: True
```

`ssh_pwauth` 配置 `/etc/ssh/sshd_config` 里 `PasswordAuthentication` 字段值。

# 正式入门

---

## [必读：官方文档](https://cloudinit.readthedocs.io/en/latest/index.html)

* 工业级标准（[主流 Linux 发行版、公有云服务提供商、私有云平台、裸机安装](https://cloudinit.readthedocs.io/en/latest/topics/availability.html)）
* 支持从多种「数据源」加载用户配置，定制从「基础镜像」到「个性化可用系统」的自动化实现

---

| 支持的发行版 | 支持的公有云 | 支持的私有云 |
| --- | --- | --- |
| Ubuntu<br />SLES/openSUSE<br />RHEL/CentOS<br />Fedora<br />Gentoo Linux<br />Debian<br />ArchLinux<br />FreeBSD<br />NetBSD<br />OpenBSD<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /> | Amazon Web Services<br />Microsoft Azure<br />Google Cloud Platform<br />Oracle Cloud Infrastructure<br />Softlayer<br />Rackspace Public Cloud<br />IBM Cloud<br />Digital Ocean<br />Bigstep<br />Hetzner<br />Joyent<br />CloudSigma<br />Alibaba Cloud<br />OVH<br />OpenNebula<br />Exoscale<br />Scaleway<br />CloudStack<br />AltCloud<br />SmartOS<br />HyperOne<br />Rootbox<br /> | Bare metal installs<br />OpenStack<br />LXD<br />KVM<br />Metal-as-a-Service (MAAS)<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />|

# 查看当前已安装 Cloud-Init 版本

---

```bash
cloud-init --version
# /usr/bin/cloud-init 19.4-33-gbb4131a2-0ubuntu1~18.04.1
```

根据以上版本信息，推荐阅读[官方 v19.4 版文档](https://cloudinit.readthedocs.io/en/19.4/index.html) 。

# [数据源](https://cloudinit.readthedocs.io/en/19.4/topics/datasources.html)

---

* 「数据源」指的是 `cloud-init` 的配置数据来源，通常来自用户（例如 `user-data`）或来自创建配置驱动器的云（例如 `meta-data` ）。 
* 典型的「用户数据」包括「文件」，「yaml」和「Shell 脚本」
* 典型的「元数据」包括「服务器名称」，「实例 ID」，「显示名称」和「其他特定于云服务提供商」的详细信息

---

实例（Instance）在云计算场景中，一般指「云主机实例」。对于 `Virtualbox` 来说，每一个本地虚拟机也可以看作是一个「实例」。

---

当前系统上执行过 `Cloud-Init` 之后会将「元数据」保存在 `/run/cloud-init/instance-data.json` ，如下所示是「第一个 🌰 」对应的「元数据」：

```json
{
 "base64_encoded_keys": [],
 "ds": {
  "_doc": "EXPERIMENTAL: The structure and format of content scoped under the 'ds' key may change in subsequent releases of cloud-init.",
  "meta_data": {
   "dsmode": "net",
   "instance-id": 1,
   "local-hostname": "cuc-cloud-init"
  }
 },
 "sensitive_keys": [],
 "v1": {
  "_beta_keys": [
   "subplatform"
  ],
  "availability-zone": null,
  "availability_zone": null,
  "cloud-name": "unknown",
  "cloud_name": "unknown",
  "instance-id": "1",
  "instance_id": "1",
  "local-hostname": "cuc-cloud-init",
  "local_hostname": "cuc-cloud-init",
  "platform": "nocloud",
  "public_ssh_keys": [],
  "region": null,
  "subplatform": "config-disk (/dev/sr0)"
 }
}
```

---

[已知支持数据源类型](https://cloudinit.readthedocs.io/en/19.4/topics/datasources.html#known-sources)

| 排                     | 名                    | 不       | 分          | 先后               |
| ---                    | ---                   | ---      | ---         | ---                |
| Alibaba Cloud (AliYun) | Alt Cloud             | Azure    | CloudSigma  | CloudStack         |
| Config Drive           | Digital Ocean         | E24Cloud | Amazon EC2  | Exoscale           |
| Fallback/None          | Google Compute Engine | MAAS     | **NoCloud** | OpenNebula         |
| OpenStack              | Oracle                | OVF      | Rbx Cloud   | SmartOS Datasource |
| ZStack                 |                       |          |             |                    |

---

## 查看我们在虚拟机里使用的数据源类型

```bash
cloud-id
# nocloud
```

# [NoCloud](https://cloudinit.readthedocs.io/en/19.4/topics/datasources/nocloud.html#nocloud)

---

回顾之前我们创建 iso 镜像文件时使用的命令

```bash
genisoimage -output init-cidata.iso -volid cidata -joliet -rock user-data meta-data
```

* `-volid cidata` 指定新创建的 iso 文件的「卷标识」为 `cidata`

![](images/cloud-init/nocloud-cidata.png)

---

回顾之前我们创建 iso 镜像文件时使用的命令

```bash
genisoimage -output init-cidata.iso -volid cidata -joliet -rock user-data meta-data
```

![](images/cloud-init/nocloud-contents.png)

* iso 镜像文件里的文件名必须是 `user-data` 和 `meta-data`

---

回顾之前的 `meta-data` 文件内容

```yaml
instance-id: 1
local-hostname: cuc-cloud-init
```

其中 `instance-id: 1` 用来告诉 `cloud-init` 引擎该实例「是否首次启动」。

```bash
# 查看该实例启动过一次之后在当前系统内留下的痕迹
ls /var/lib/cloud/instances/1/
# boot-finished     datasource  obj.pkl  sem            user-data.txt.i  vendor-data.txt.i
# cloud-config.txt  handlers    scripts  user-data.txt  vendor-data.txt
```

---

其中 `boot-finished` 文件记录了该实例定义的启动时间，例如：

```bash
cat /var/lib/cloud/instances/1/boot-finished
# 11.28 - Tue, 14 Apr 2020 07:33:47 +0000 - v. 19.4-33-gbb4131a2-0ubuntu1~18.04.1
```

---

当上述目录结构存在时，只要 `init-cidata.iso` 内容不变。即使一直挂载在虚拟机的光驱里，每次启动虚拟机系统时，也不会再重新执行一遍光盘里定义的 `cloud-init` 操作了。

---

如果希望重新执行 `init-cidata.iso` 里定义的操作，需要变更 `meta-data` 文件里的 `instance-id` 赋值为 `/var/lib/cloud/instances/` 下不存在重名子目录的其他值。

# [调试 user-data](https://cloudinit.readthedocs.io/en/19.4/topics/faq.html#how-can-i-debug-my-user-data)

---

```bash
# 验证 user-data 文件是否存在语法错误
cloud-init devel schema -c user-data --annotate
# Valid cloud-config file user-data
```

# 认识模块

---

* [/etc/cloud/cloud.cfg](https://cloudinit.readthedocs.io/en/19.4/topics/cli.html#modules) 中定义了当前系统中 `Cloud-Init` 在「不同阶段」加载了哪些模块。

---

## [Cloud-Init 主要阶段](https://cloudinit.readthedocs.io/en/19.4/topics/boot.html)

结合 `/etc/cloud/cloud.cfg` 文件内容来理解不同「启动阶段」：文件中一共定义了 3 个阶段:

* init
* config
* final

每个阶段可以「完成」哪些操作可以根据包含的「模块」功能知悉。

---

`/etc/cloud/cloud.cfg` 🌰

```yaml
# ref: https://cloudinit.readthedocs.io/en/19.4/topics/modules.html
# 以下各个阶段定义的「模块」均在以上官方文档中有详细使用说明

# The modules that run in the 'init' stage
cloud_init_modules:
 - migrator
 - seed_random
 - bootcmd
 - write-files
 - growpart
 - resizefs
 - disk_setup
 - mounts
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - ca-certs
 - rsyslog
 - users-groups
 - ssh

# The modules that run in the 'config' stage
cloud_config_modules:
# Emit the cloud config ready event
# this can be used by upstart jobs for 'start on cloud-config'.
 - emit_upstart
 - snap
 - ssh-import-id
 - locale
 - set-passwords
 - grub-dpkg
 - apt-pipelining
 - apt-configure
 - ubuntu-advantage
 - ntp
 - timezone
 - disable-ec2-metadata
 - runcmd
 - byobu

# The modules that run in the 'final' stage
cloud_final_modules:
 - package-update-upgrade-install
 - fan
 - landscape
 - lxd
 - ubuntu-drivers
 - puppet
 - chef
 - mcollective
 - salt-minion
 - rightscale_userdata
 - scripts-vendor
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - phone-home
 - final-message
 - power-state-change
```

---

结合 [官方文档里「启动阶段」](https://cloudinit.readthedocs.io/en/19.4/topics/boot.html) 一节的描述可知：`init` 阶段又可以分为：

* Generator
* Local
* Network

# 理解模块

---

相当于「导入函数」或「导入库」的作用，如果在指定「启动阶段」没有「定义」使用某个「模块」，则在 `user-data` 中不能调用相应指令。

---

再回看「第一个 🌰 」

```yaml
#cloud-config
password: mypassword 
chpasswd: { expire: False }
ssh_pwauth: True
```

上述 3 个配置指令 `password`, `chpasswd`, `ssh_pwauth` 均定义在 [set-passwords](https://cloudinit.readthedocs.io/en/latest/topics/modules.html#set-passwords) 模块中。

# 理解缺省设置

---

```yaml
# The top level settings are used as module
# and system configuration.

# A set of users which may be applied and/or used by various modules
# when a 'default' entry is found it will reference the 'default_user'
# from the distro configuration specified below
users:
   - default

# If this is set, 'root' will not be able to ssh in and they
# will get a message to login instead as the default $user
disable_root: true

# This will cause the set+update hostname module to not operate (if true)
preserve_hostname: false

# Example datasource config
# datasource:
#    Ec2:
#      metadata_urls: [ 'blah.com' ]
#      timeout: 5 # (defaults to 50 seconds)
#      max_wait: 10 # (defaults to 120 seconds)

# 此处省略 3 个阶段的模块定义相关指令

# System and/or distro specific settings
# (not accessible to handlers/transforms)
system_info:
   # This will affect which distro class gets used
   distro: ubuntu
   # Default user name + that default users groups (if added/used)
   default_user:
     name: ubuntu
     lock_passwd: True
     gecos: Ubuntu
     groups: [adm, audio, cdrom, dialout, dip, floppy, lxd, netdev, plugdev, sudo, video]
     sudo: ["ALL=(ALL) NOPASSWD:ALL"]
     shell: /bin/bash
   # Automatically discover the best ntp_client
   ntp_client: auto
   # Other config here will be given to the distro class and/or path classes
   paths:
      cloud_dir: /var/lib/cloud/
      templates_dir: /etc/cloud/templates/
      upstart_dir: /etc/init/
   package_mirrors:
     - arches: [i386, amd64]
       failsafe:
         primary: http://archive.ubuntu.com/ubuntu
         security: http://security.ubuntu.com/ubuntu
       search:
         primary:
           - http://%(ec2_region)s.ec2.archive.ubuntu.com/ubuntu/
           - http://%(availability_zone)s.clouds.archive.ubuntu.com/ubuntu/
           - http://%(region)s.clouds.archive.ubuntu.com/ubuntu/
         security: []
     - arches: [arm64, armel, armhf]
       failsafe:
         primary: http://ports.ubuntu.com/ubuntu-ports
         security: http://ports.ubuntu.com/ubuntu-ports
       search:
         primary:
           - http://%(ec2_region)s.ec2.ports.ubuntu.com/ubuntu-ports/
           - http://%(availability_zone)s.clouds.ports.ubuntu.com/ubuntu-ports/
           - http://%(region)s.clouds.ports.ubuntu.com/ubuntu-ports/
         security: []
     - arches: [default]
       failsafe:
         primary: http://ports.ubuntu.com/ubuntu-ports
         security: http://ports.ubuntu.com/ubuntu-ports
   ssh_svcname: ssh
```

# 更复杂的 🌰 们

---

[官方文档中给出的更多 cloud-config 配置文件示例](https://cloudinit.readthedocs.io/en/19.4/topics/examples.html)


