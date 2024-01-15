---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第一章：Linux基础

---

## GNU is NOT Unix

> GNU is a recursive acronym for "GNU's Not Unix!", chosen because GNU's design is Unix-like, but differs from Unix by being free software and containing no Unix code.

# Linux 与 Unix 的渊源

---

## 里程碑事件 - Unix

* 1969 年，Ken Thompson(K&T) 和 Dennis Ritchie(D&R) 在贝尔实验室开发了 Unix 操作系统，它是一个多任务、多用户的分时系统，具有高度的可移植性和灵活性。
* 1971-1972年，D&R 发明了 C 语言，并用它重写了 Unix 的大部分源代码，使得 Unix 可以在不同的硬件平台上运行。
* 1973年，Unix 的第四版发布，这是第一个广泛传播的版本，它被许多学术和研究机构使用和修改，产生了许多不同的 Unix 变体，如 BSD、Solaris、HP-UX、AIX 等。

---

## 里程碑事件 - GNU

* 1983年，Richard Stallman 发起了 GNU 项目，旨在创建一个完全自由和开源的类 Unix 操作系统，他开发了许多 Unix 的实用程序和工具，如 GCC、Emacs、Bash 等，并制定了 GNU 通用公共许可证（GPL）。

---

## 里程碑事件 - Linux

* 1991年，Linus Torvalds 在芬兰赫尔辛基大学学习时，为了个人兴趣，编写了一个与 Unix 兼容的操作系统内核，他称之为 Linux，并公开了源代码，邀请其他人一起完善。
* 1992年，Linux 内核与 GNU 的软件结合，形成了一个完整的自由和开源的操作系统，这就是我们今天所说的 Linux 系统。
* 1994年，Linux 内核 1.0 正式版发布，标志着 Linux 系统的成熟，从此 Linux 系统开始在各个领域广泛应用，如服务器、桌面、嵌入式、移动等。

--- 

## [Linux内核](https://www.kernel.org/)

<a href="https://en.wikipedia.org/wiki/Linux_kernel">![](images/chap0x01/LinuxKernel.png)</a>

# Linux生态圈

---

![](images/chap0x01/LinuxEcosystem.png)

---

| 英文                                | 中文           |
| :-                                  | :-             |
| Linux Development Community         | Linux 开发社区 |
| Linux Distribution                  | Linux 发行版   |
| Carrier                             | 电信运营商     |
| Network Equipment Provider          | 网络设备提供商 |
| OSS(Open-source Software) Community | 开源软件社区   |
| ISV(Independent Software Vendor)    | 独立软件开发商 |
| Hardware Manufacturer               | 硬件制造商     |

---

## Linux 生态圈 - 开发社区与 Git

* 早期的 Linux 内核开使用发商业化的版本控制软件 BitKeeper 进行代码管理，但开源社区对这个选择充满了质疑
* Linus 本人最初是希望避免重复造轮子，但他本人又对现有的版本控制系统均不满意，于是在 2005 年花了 10 天时间开发完成了第一个 Git 版本
* 不同于 CVS、SVN 等集中式版本控制工具，Git 采用 **分布式** 版本管理，不需要服务器端软件


---

## Git 与 GitHub

* Git 是一款免费、开源的分布式版本控制系统
* GitHub 是用 Git 做版本控制为全球开源软件作者提供集中的代码托管平台
    * 针对私有闭源软件项目提供收费的代码托管服务
    * 目前主流的开源项目普遍将代码托管在 GitHub 上，软件开发过程可以被全世界所有人透明的查看和监管

---

## GitHub

* [GitHub在知乎上的主题索引](https://www.zhihu.com/topic/19566035)
* Google: github awesome xxxx
    * github awesome android
    * github awesome security
    * github awesome javascript

---

## Linux生态圈 - [发行版](https://en.wikipedia.org/wiki/Comparison_of_Linux_distributions) {id="linux-distros-1"}

* 基于 Linux 内核构建完整操作系统
    * [Debian](https://www.debian.org/): 非营利性组织运营的开源软件构建发布版本
        * [Ubuntu](http://www.ubuntu-china.cn/about/)：商业公司Canonical基于Debian构建和维护
            * [Linux Mint](https://www.linuxmint.com/about.php)：开源社区维护
    * Fedora
        * RHEL: Red Hat Enterprise Linux
            * [CentOS is dead, CentOS Stream `is not a replacement`](https://blog.centos.org/2020/12/future-is-centos-stream/)
                * CentOS Stream, founded in 2019, is “a rolling preview of what's next in RHEL.”
            * Oracle Linux
---

## Linux生态圈 - [发行版](https://en.wikipedia.org/wiki/Comparison_of_Linux_distributions) {id="linux-distros-2"}

* 基于 Linux 内核构建完整操作系统
    * [SUSE](https://www.suse.com/)
        * SLES: SUSE Linux Enterprise Server
        * [openSUSE](https://zh.opensuse.org/)
    * 其他发行版
        * Arch Linux
        * Gentoo
        * Slackware

---

## Linux生态圈 - [发行版](https://en.wikipedia.org/wiki/List_of_Linux_distributions) {id="linux-distros-3"}

<a href="http://tuxradar.com/content/best-distro-2011">![](images/chap0x01/LinuxPublisherComparison.jpg)</a>


---

### 内核、GNU 与 发行版

![](images/chap0x01/linux-gnu-distro.png)

---

## Linux生态圈 - LSB

* [Linux Standard Base, LSB](https://wiki.linuxfoundation.org/lsb/start)
* 愿景和使命
    * 当Linux成为一个平台之后，应用软件开发者希望实现 **write once** (on one Linux distribution will) **run everywhere** (on other Linux distributions) 
    * 不仅如此，应用软件开发者希望平台的升级更新不要影响到他们已完成代码的可用性和兼容性

---

## Linux生态圈 - CGL

* [Carrier Grade Linux, CGL](https://wiki.linuxfoundation.org/cgl/start) ：电信运营商级Linux
* 愿景和使命
    * 调研网络设备提供商和电信运营商的需求并为Linux发行版厂商制定实现规范
    * 帮助上游厂商在技术上整合实现以满足上述需求标准

---

## Linux生态圈 - [CGL](https://www.linuxfoundation.org/sites/lfcorp/files/CGL_5.0_Specification.pdf)

需求类别

* 可用性
* 集群
* 可服务
* 性能
* 标准化
* 硬件
* 安全

# OSS (Open-source Software) Community 开源软件社区

---

* [The largest open source community in the world on GitHub](https://github.com/open-source)
* [Open Source Licenses](https://opensource.org/licenses)

<a href="http://events.linuxfoundation.org/sites/events/files/slides/lcna15_linuxone.pdf">![](images/chap0x01/OpenSourceInTheEnterprise.png)</a>

---

## ISV(Independent Software Vendor) 独立软件开发商

<a href="http://events.linuxfoundation.org/sites/events/files/slides/lcna15_linuxone.pdf">![](images/chap0x01/OpenSourceISV.png)</a>

---

## Hardware Manufacturer  硬件制造商 

* [Hardware on LinuxMint](https://community.linuxmint.com/hardware)
* [Ubuntu 认证硬件](https://certification.ubuntu.com/)
* [Hardware on Debian](https://wiki.debian.org/Hardware)
* [Hardware on RedHat](https://hardware.redhat.com)

# 开源与商业化

---

* Linux基金会
* OpenStack基金会
* Apache
* Canonical

---

## Linux基金会 {id="linux-foundation"}

* 孵化了[大量知名开源项目](https://www.linuxfoundation.org/projects)
    * 例如：KVM、Xen、nodejs、Open vSwitch等
* Linux基金会采用的是[会员制，分为：准会员、银级、金级、白金级四个等级，白金级是最高等级](https://www.linuxfoundation.org/about/bylaws)。
    * [白金会员（年费50万美元）：思科、富士通、惠普企业、华为、IBM、英特尔、NEC、甲骨文、高通、三星和微软](https://www.linuxfoundation.org/members/corporate)
    * 黄金会员（年费10万美元）
    * 银级会员，按员工数量规模浮动5千美元/年 ～ 2万美元/年
    * 准会员：非盈利组织和政府实体才可加入，无投票权，费用采取审核批准制（免费与否不固定）

---

## [OpenStack基金会](https://www.openstack.org/foundation/) {id="openinfra-1"}

* OpenStack由NASA（美国国家航空航天局）和Rackspace合作研发并发起，旨在为公共及私有云的建设与管理提供软件的开源项目
* 2020年10月正式升级为：开源基础设施基金会 - OIF (Open Infrastructure Foundation)
* 截止2017年2月，共有来自全球180个国家超过6万名独立会员。截止2021年2月，会员数已超过10万人

---

## [OpenStack基金会](https://www.openstack.org/foundation/) {id="openinfra-2"}

* [白金会员](https://www.openstack.org/join/)：50万美元/年起步，2名全职工程师贡献
* 黄金会员：5万 ～20万美元/年，按照企业净收入的0.025%为参考
* 企业赞助：创业公司1万美元/年起，其他公司2.5万美元/年起
* 其他主要收入方式：认证、培训、商业化服务支持（安装、部署、架构、集成、定制开发等）

---

## Apache

* Apache软件基金会，简称为ASF，它支持的Apache项目与子项目中，所发行的软件产品都需要遵循Apache许可证（Apache License）。
* 目前其已经监管了[数百个开源项目](https://www.apache.org/index.html#projects-list)，其中的知名项目包括：Apache HTTP Server、Hadoop、Spark、Kafka、Groovy、Struts等。
* [会员赞助制](https://www.apache.org/foundation/sponsorship.html)，这里是[赞助商名单致谢清单](https://www.apache.org/foundation/thanks.html)
    * 白金：12.5万美元/年
    * 黄金：5万美元/年
    * 白银：2.5万美元/年
    * 青铜：6千美元/年
* [任性打赏捐赠](https://www.apache.org/foundation/contributing.html)

---

## [Canonical](https://www.canonical.com/)

* [科能软件有限公司（Canonical Ltd.） 是一家私人公司，由南非的企业家马克·沙特尔沃思创建，主要为了促进开源软件项目。](https://en.wikipedia.org/wiki/Canonical_\(company\))
* Canonical在曼岛登记注册，其雇员分布在世界各地，其主要办事处在伦敦，在波士顿、圣保罗、蒙特利尔、上海、台北和马恩岛也有分公司。
* 订阅制增值服务：[Ubuntu Pro](https://ubuntu.com/pro)
* 主要产品：Ubuntu家族的Linux发行版

本课程主要以 Ubuntu 系统为基础实验环境，兼顾 CentOS 等其他常用服务器发行版。

# Ubuntu

---

## 不同版本的维护周期规划

[![](images/chap0x01/UbuntuLTS.png)](https://ubuntu.com/about/release-cycle)

---

## 长期支持版本

[![](images/chap0x01/UbuntuLTS-ESM.png)](https://ubuntu.com/about/release-cycle)

# Ubuntu安装 {id="ubuntu-install"}

---

* 物理主机安装
* 虚拟机安装

---

## 安装前准备

* 优先选择当前可用最新的长期支持版本（LTS），下载iso文件
    * 刻盘 / U盘
* 新手避免直接在物理主机上安装Linux，推荐在虚拟机里安装（直接挂载使用iso文件）
* 磁盘容量准备
    * [桌面版](https://www.ubuntu.com/download/desktop/install-ubuntu-desktop)：至少20GB
    * [服务器](https://www.ubuntu.com/download/server/install-ubuntu-server)：至少10GB
    * 虚拟机安装推荐使用**动态分配**的虚拟硬盘，预分配80GB磁盘空间
* 优先选择64位系统

---

## 安装中

* 推荐在安装时软件包选择界面勾选（使用**空格键**确认勾选，使用**方向键**移动菜单光标）安装**OpenSSH server**
* <del>建议断网安装，避免安装时由于网速慢、联网更新会导致整个安装过程时间较长</del>

---

## 安装后

* 及时备份纯净系统

对于使用虚拟机软件安装的虚拟机系统，建议使用虚拟机自带的虚拟机导出功能或直接备份虚拟硬盘文件。

---

### Virtualbox 专属的基础镜像制作

关键词：`介质管理` - `虚拟硬盘` - `多重加载`

---

## 安装过程自动化（无人值守）

* [Preseed by Debian](https://wiki.debian.org/DebianInstaller/Preseed)
    * [基于官方iso格式安装镜像制作无人值守定制安装镜像](https://help.ubuntu.com/community/InstallCDCustomization)
    * [Automating the installation using preseeding by Ubuntu](https://help.ubuntu.com/lts/installation-guide/amd64/apb.html)
        * [Ubuntu官方提供的preseed示例文件](https://help.ubuntu.com/lts/installation-guide/example-preseed.txt)
* 基于 [subiquity](https://github.com/CanonicalLtd/subiquity)  - Ubuntu 18.04+ only
* [Kickstart by RedHat](http://pykickstart.readthedocs.io/en/latest/kickstart-docs.html)
    * [Cobbler](http://cobbler.github.io/)

# 命令行

---

* CLI: **Command** Line Interface
    * 使用键盘输入命令，屏幕文字输出结果
* GUI: Graphics User Interface
    * 使用键鼠（也包括红外、体感等新型交互传感器技术）输入命令，图文音输出结果
* CUI: **Conversational** User Interface
    * 使用语音输入命令，五感反馈
    * AI驱动重新发明CLI

---

## 命令行的特点

图形用户界面让简单的任务更容易完成，而命令行界面使完成复杂的任务成为可能

* 全键盘输入：专业工作效率高
* 面向自动化：管道、文件、脚本

# 内置帮助系统

---

```bash
man man

...
The  table below shows the section numbers of the manual followed by the types of pages they contain.
       1   Executable programs or shell commands
       2   System calls (functions provided by the kernel)
       3   Library calls (functions within program libraries)
       4   Special files (usually found in /dev)
       5   File formats and conventions eg /etc/passwd
       6   Games
       7   Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
       8   System administration commands (usually only for root)
       9   Kernel routines [Non standard]
...

```

---

* 使用**h**获取man帮助系统中的内置帮助（快捷键映射定义），学习如何使用man
* 使用**q**退出man帮助系统或子页面
* 使用**上下**键滚动页面，使用**空格**键向下翻页
* 使用**/**键查找关键词（不区分大小写），使用**n**查看下一个匹配结果

---

man的常用命令行参数

```bash
# 安装开发相关的manual
sudo apt-get install manpages-dev

# 在所有section中查找主题为printf的手册页
man -a printf

# 在所有manual的正文中查找printf关键词
man -k printf

# 直接查看系统调用类帮助文档中主题名为printf的手册页
man 3 printf
```

---

## 内置帮助系统 - 惯例

* 大多数命令行程序都支持 `-h` 或 `--help` 参数来获取内置的简洁使用帮助

# Shell

---

## [什么是shell](https://www.gnu.org/software/bash/manual/html_node/What-is-a-shell_003f.html)

* shell 就是一个执行命令的「宏」处理器：输入的文本和符号被扩展为更「宏大」的表达式
* Unix shell 即是一个「命令解释器」，也是一种「编程语言」
* shell 的运行模式：交互模式、非交互模式
    * 交互模式：从键盘输入指令解释执行
    * 非交互模式：从文件读取指令解释执行
* shell 同时支持同步或异步执行指令

---

## [shell家族](https://en.wikipedia.org/wiki/Unix_shell)

![](images/chap0x01/unix-shells-large.png)

---

## [命令行快捷键](http://billie66.github.io/TLCL/book/chap09.html)

* 自动补全
    * **TAB**
* 重复输入命令
    * **上下键**
    * **Ctrl-R**

# 文本编辑与查看

---

* echo
* cat
* less
* vim / vimtutor
* sort
* uniq
* wc

---

问：如何生成一个随机的字符串？

---

答：让新手退出Vim。

# SSH与远程服务器管理

---

* 免密登录 ***目的***
    * ssh-copy-id ***手段***
    * $HOME/.ssh/authorized_keys ***手段***
* SSH 跳板与堡垒主机

```bash
# ProxyCommand
man ssh_config
```

* `SSH服务器安全加固`

---

## SSH 客户端

* Linux / Mac
    * ssh
* Windows
    * [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
    * [putty](http://www.putty.org/)
    * [xshell](https://www.netsarang.com/download/down_xsh.html)
    * [MobaXterm](http://mobaxterm.mobatek.net/)
    * [git bash](https://gitforwindows.org/)

# Virtualbox虚拟机实验环境建议

---

* 使用双网卡：Host-only + NAT

# 参考文献

---

* [History of Linux from WikiPedia](https://en.wikipedia.org/wiki/History_of_Linux)
* [Arch compared to other distributions](https://wiki.archlinux.org/index.php/Arch_compared_to_other_distributions_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))
* [GitHub在知乎上的主题索引](https://www.zhihu.com/topic/19566035)
* [Ubuntu Installation Guide（官方文档）](https://help.ubuntu.com/lts/installation-guide/)
* [How to install Ubuntu - The Ubuntu Installation Guide](https://builtvisible.com/the-ubuntu-installation-guide/)
* [How do I create an EFI-bootable ISO of a customized version of Ubuntu?](http://askubuntu.com/questions/457528/how-do-i-create-an-efi-bootable-iso-of-a-customized-version-of-ubuntu)
* [How do I create a completely unattended install of Ubuntu Desktop 16.04.1 LTS?](http://askubuntu.com/questions/806820/how-do-i-create-a-completely-unattended-install-of-ubuntu-desktop-16-04-1-lts)
* [快乐的Linux命令行](http://billie66.github.io/TLCL/index.html) | [The Linux Command Line](http://linuxcommand.org/tlcl.php)


