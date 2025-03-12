---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第二章：（实验）

---

## From GUI to CLI

## 软件环境

* 当前课程推荐的 Linux 发行版本
    * 服务器环境（Ubuntu）


# 实验问题

---

* 【软件包管理】在目标发行版上安装 `tmux` 和 `tshark` ；查看这 2 个软件被安装到哪些路径；卸载 `tshark` ；验证 `tshark` 卸载结果

---

* 【文件管理】复制以下 `shell` 代码到终端运行，在目标 Linux 发行版系统中构造测试数据集，然后回答以下问题：
    * 找到 `/tmp` 目录及其所有子目录下，文件名包含 `666` 的所有文件
    * 找到 `/tmp` 目录及其所有子目录下，文件内容包含 `666` 的所有文件

```bash
cd /tmp && for i in $(seq 0 1024);do dir="test-$RANDOM";mkdir "$dir";echo "$RANDOM" > "$dir/$dir-$RANDOM";done
```

---

* 【文件压缩与解压缩】练习课件中 [文件压缩与解压缩](https://c4pr1c3.github.io/LinuxSysAdmin/chap0x02.md.html#/12/1) 一节所有提到的压缩与解压缩命令的使用方法
* 【跟练】 [子进程管理实验](https://asciinema.org/a/f3ux5ogwbxwo2q0wxxd0hmn54)
* 【硬件信息获取】目标系统的 CPU、内存大小、硬盘数量与硬盘容量

# 在线实验环境任务清单

---

* [ ] 掌握 scp 的使用场景和使用方法
* [ ] 掌握常用文件压缩与解压缩工具的使用方法 tar, 7zip
    * [ ] 解压缩文件: .rar, .7z, .gz, .tar.gz, .tar, .bz
    * [ ] 压缩文件与目录: .tar.gz, .7z

---

* [ ] 掌握按文件名查找文件的方法
* [ ] 掌握按文件创建时间查找文件的方法
* [ ] 掌握按文件大小查找文件的方法
* [ ] 掌握按文件名找到文件后检索文件内容是否包含指定文本的方法
* [ ] 掌握将查找到的文件计算 SHA-256 并将计算结果写入一个指定文本文件的方法


