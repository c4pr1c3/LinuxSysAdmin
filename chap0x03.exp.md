---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第三章：（实验）

---

## 实验报告任务清单

* 在 `本地虚拟机` 中完成课件 [本章完成后的自查清单](https://c4pr1c3.github.io/LinuxSysAdmin/chap0x03.md.html#/16) 所有实验任务，实验操作记录在实验报告中。
* 完整实验操作过程通过 [asciinema](https://asciinema.org) 进行录像并上传，在实验报告中引用 asciinema 在线可访问链接。
* 对于 `asciinema` 已进行操作的实验任务，实验报告中需提供 `asciinema` 在线可访问链接；一个任务对应一个在线链接；相应的实验操作可以在实验报告中简要描述。
* 对于 `asciinema` 不方便呈现的操作步骤，可以通过图文并茂的方式进行描述说明。

## 在线实验环境任务清单

**无需写入实验报告** ，只需在 `共享课程服务器` 完成实验任务即可，相应操作记录作为平时成绩计算的日志依据。

---

* [ ] 自主探索课件中的实验任务哪些需要 root 权限才能完成
* [ ] 自主探索课件中的实验任务哪些无需 root 权限也能完成

---

* [ ] 网络故障排查初步
  * [ ] 查看网络接口状况和网络基本信息 ip a, ip link
  * [ ] 查看局域网基本信息 ip neigh
  * [ ] 查看路由表和默认路由 ip r
  * [ ] 检查网络层连通性 ping
  * [ ] 检查从源到目的的路由链路信息 mtr, tracepath
  * [ ] 检查域名解析故障 resolvectl, dig

