---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第七章：DHCP与DNS服务

---

## Just Get Network Works

# [动态主机配置协议 (DHCP)](https://help.ubuntu.com/lts/serverguide/dhcp.html)

---

动态主机配置协议 (DHCP) 是一种网络服务，相对于手工为每台网络主机配置，它使网络主机可能自动被服务器指定设置。被配置成 DHCP 客户端的计算机并不能控制其从 DHCP 服务器得到的设置，且该配置对于计算机用户来说是透明的。

由 DHCP 服务器提供给 DHCP 客户端最常用的设置包括：

* IP地址和子网掩码
* 默认网关IP地址
* （本地）DNS解析服务器IP地址

---

一个 DHCP 服务器也支持配置如下属性，如：

* 主机名 / 域名
* NTP时间服务器
* 打印服务器

# DHCP服务器的常见客户端地址配置策略

---

**手工分配（基于客户端网卡MAC地址）**

DHCP服务器根据网络中每个联网网卡的物理地址为其提供一个固定的配置，当使用该网卡的客户端发起DHCP请求时可以确保客户端网络地址自动配置的确定性。

---

**动态分配（基于地址池）**

DHCP服务器从一个地址池（有时又被称为一个地址段或区间）选择一个IP地址，根据服务器配置保留一段时间或租期内有效，或者客户端主动通知服务器该地址已不再被使用。在这种策略之下，客户端按照“先到先得”原则动态获取网络配置信息。当一个DHCP客户端在该网络中离线一段时间，该配置将自动过期并被释放回地址池用于分配给其他DHCP客户端。这种方法获得的地址可被租用或使用一段时间，过期之后客户端需要重新和服务器协商保留该地址的使用权。

---

**自动分配**

DHCP服务器通常是给客户端分配一个临时地址，但也能设置有效期为永不过期，从而达到客户端既能自动获取IP地址又能永久使用的效果。

---

防御[Rogue DHCP](https://en.wikipedia.org/wiki/Rogue_DHCP)

# [DNS](https://help.ubuntu.com/lts/serverguide/dns.html)

---

DNS(域名解析服务)是将IP地址与FQDN(fully qualified domain name，全称域名)相互转换的一种互联网服务。

---

## ***BIND9***服务的主要角色

When configured as a caching nameserver BIND9 will find the answer to name queries and remember the answer when the domain is queried again.

As a primary master server BIND9 reads the data for a zone from a file on it's host and is authoritative for that zone.

In a secondary master configuration BIND9 gets the zone data from another nameserver authoritative for the zone.

# 常见DHCP服务器

---

* dnsmasq
* isc-dhcp-server

# 常见DNS服务器 {id="dns-common-svrs"}

---

* dnsmasq
* isc-dhcp-server
* bind9

# 参考文献

---

* [Dynamic Host Configuration Protocol from Ubuntu Official Documentation](https://help.ubuntu.com/lts/serverguide/dhcp.html)
* [DNS from Ubuntu Official Documentation](https://help.ubuntu.com/lts/serverguide/dns.html)

