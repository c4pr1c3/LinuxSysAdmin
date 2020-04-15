---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第八章的「番外」索引

---

* [PXE](pxe.md)
* [ansible](ansible.md)
* [Cloud-Init](cloud-init.md)

# 「番外」与「番外」的区别与联系

---

老子《道德经》有云：

> 道生一，一生二，二生三，三生万物。

---

## 零一二三

* 零：裸设备，无操作系统
* 一：（最小化）安装「操作系统」（预装「最普遍需要」的基础软件）
* 二：（最小化）安装「通用基础设施软件」和「基础配置」
* 三：安装「专用基础设施软件」

---

## 零一二三及「万物」的 🌰

* 零：新购买的服务器、新创建的虚拟机
* 一：Ubuntu, Debian, CentOS + Cloud-Init, libc, sh 
* 二：Python, OpenSSH Server, Ruby, Puppet, Chef, Docker
    * 基础配置：SSH 免密登录、创建新用户、SSH 安全加固配置等
* 三：Apache httpd Server, Nginx, Bind9, ntpd
* [万物](https://github.com/awesome-selfhosted/awesome-selfhosted)：Wordpress, Drupal, Joomla

# 重新认识本课程主线内容

---

## 零生一

> 从裸机（未安装操作系统的物理主机或虚拟机）到安装好基本系统

* 第 1 章
    * 其中「无人值守安装镜像的制作」实验可以完成「从零到一」的 **自动化**

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

# 小结

---

* [PXE](pxe.md) 和 `无人值守安装镜像` 可以解决 `从零到一` **自动化** 问题
* [ansible](ansible.md) 解决 `从二到万物` **自动化** 问题
* [Cloud-Init](cloud-init.md) 可以解决 `从一到二`、`从一到三` 甚至 `从一到万物` 的 **自动化** 问题


