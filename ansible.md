---
title: "Linux系统与网络管理"
author: 黄玮
output: revealjs::revealjs_presentation
---

# 番外：Ansible

---

最权威，没有之一：[Ansible Core - Official Documentation](http://docs.ansible.com/ansible/latest/index.html)

最权威，没有之一：[Ansible Core - Official Documentation](http://docs.ansible.com/ansible/latest/index.html)

最权威，没有之一：[Ansible Core - Official Documentation](http://docs.ansible.com/ansible/latest/index.html)

---

## 提纲

* 安装
* 核心术语
* 项目结构

# 版本说明

---

```bash
ansible --version
ansible 2.4.0.0
  config file = None
  configured module search path = [u'$HOME/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = $ANSIBLE_ROOT/libexec/lib/python2.7/site-packages/ansible
  executable location = /usr/local/bin/ansible
  python version = 2.7.14 (default, Feb  3 2018, 15:37:41) [GCC 4.2.1 Compatible Apple LLVM 9.0.0 (clang-900.0.39.2)]
```

# [安装](http://docs.ansible.com/ansible/latest/intro_installation.html) { id="installation" }

---

Ansible 官方推荐 ``Red Hat Enterprise Linux (TM)``, ``CentOS``, ``Fedora``, ``Debian``, ``Ubuntu`` 操作系统用户直接使用操作系统官方维护和打包的最新版软件包。除此之外，也可以通过 Python 的包管理器 ``pip`` 进行安装。

# 核心术语

---

* [Inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html)
* [Ad-Hoc Commands](http://docs.ansible.com/ansible/latest/intro_adhoc.html)
* [Playbooks](http://docs.ansible.com/ansible/latest/playbooks.html)
* [Modules](http://docs.ansible.com/ansible/latest/modules.html)
* [Ansible Vault](http://docs.ansible.com/ansible/latest/vault.html)

---

## [Inventory](http://docs.ansible.com/ansible/latest/intro_inventory.html)

* 默认全局 ``清单`` 文件：``/etc/ansible/hosts``
* **最常用**的 ``清单`` 文件：``-i <path>`` ，通过命令行参数自行指定 ``清单`` 文件路径
* [实例](https://github.com/c4pr1c3/AnsibleTutorial)

---

## [Ad-Hoc Commands](http://docs.ansible.com/ansible/latest/intro_adhoc.html)

```bash
# 使用 ansible 内置的 ping 模块
## 在 清单 文件中名为 ubuntu 的主机或主机组定义的所有主机 上执行
ansible ubuntu -i hosts -m ping
## 在 清单 文件中定义的所有 不重复主机 上执行
ansible all -i hosts -m ping

# 执行远程主机上的指令
ansible all -i hosts -a 'ip addr'
```

# [Playbooks](http://docs.ansible.com/ansible/latest/playbooks.html)

---

> Playbooks 是 Ansible 的 配置、部署和编排语言，可以用于定义远程主机强制执行策略或一般性 IT 过程。

* [Ansible 官方提供的一些示例 Playbooks](https://github.com/ansible/ansible-examples)
* 核心语言使用的 [YAML](http://docs.ansible.com/ansible/latest/YAMLSyntax.html)
* [Ansible 官方提供的指令速查词典](http://docs.ansible.com/ansible/latest/playbooks_keywords.html)

---

## YAML 快速上手 {id="yaml-quickstart"}

* （可选）`---` 定义 YAML 文件开始，`...` 定义 YAML 文件结束
* `list` 数据结构，使用 `- ` （一个短杠和一个空格）
* `dict` 数据结构，使用 `key: value` 形式
* 续行符
    * `|` 包含换行符
    * `>` 忽略换行符
* 尽可能多的使用 **双引号** 包围变量的赋值

---

## YAML 简单例子 {id="yaml-basic-examples"}

```yaml
# Employee records
-  martin:
    name: Martin D'vloper
    job: Developer
    skills:
      - python
      - perl
      - pascal
-  tabitha:
    name: Tabitha Bitumen
    job: Developer
    skills:
      - lisp
      - fortran
      - erlang

# 上述例子的等价单行写法如下：
martin: {name: Martin D'vloper, job: Developer, skill: Elite}
fruits: ['Apple', 'Orange', 'Strawberry', 'Mango']
```

---

## YAML 多行字符串例子 {id="yaml-multiple-lines"}

```yaml
include_newlines: |
            exactly as you see
            will appear these three
            lines of poetry

ignore_newlines: >
            this is really a
            single line of text
            despite appearances
```

# 变量 { id='variables' }

---

变量作用域优先级如下，自顶向下优先级依次升高：

```bash
role defaults 
inventory file or script group vars
inventory group_vars/all
playbook group_vars/all
inventory group_vars/*
playbook group_vars/*
inventory file or script host vars
inventory host_vars/*
playbook host_vars/*
host facts
play vars
play vars_prompt
play vars_files
role vars (defined in role/vars/main.yml)
block vars (only for tasks in block)
task vars (only for the task)
role (and include_role) params
include params
include_vars
set_facts / registered vars
extra vars (always win precedence)
```

# [Modules](http://docs.ansible.com/ansible/latest/modules.html)

---

常见运维任务都可以找到 `ansible` 内置模块的支持，例如：

* [文件上传、权限设置、查找、元信息获取、基于模版生成配置文件等](http://docs.ansible.com/ansible/latest/list_of_files_modules.html)
* [bower、composer、pip、pear等主流编程语言的包管理工具，apt、homebrew、yum等操作系统包管理工具](http://docs.ansible.com/ansible/latest/list_of_packaging_modules.html)
* [操作系统级别管理工具：用户/用户组管理、systemd服务管理、时区管理、内核加载模块管理等](http://docs.ansible.com/ansible/latest/list_of_system_modules.html)
* [远程命令执行、脚本执行等](http://docs.ansible.com/ansible/latest/list_of_commands_modules.html)
* [PKI 证书管理](http://docs.ansible.com/ansible/latest/list_of_crypto_modules.html)
* [常见数据库管理](http://docs.ansible.com/ansible/latest/list_of_database_modules.html)
* [常见Web基础设施管理：supervisorctl、htpasswd、apache2_module、letsencrypt等](http://docs.ansible.com/ansible/latest/list_of_web_infrastructure_modules.html)
* [常见版本控制工具管理](http://docs.ansible.com/ansible/latest/list_of_source_control_modules.html)


# [Ansible Vault](http://docs.ansible.com/ansible/latest/vault.html)

---

## [使用 Vault 加密敏感数据](http://docs.ansible.com/ansible/latest/vault.html#what-can-be-encrypted-with-vault)

可以对以下路径下的文件加密

* `group_vars/`
* `host_vars/`

也可以对 Ansible 变量加密

---

* **建议-1** 仅对需要加密的变量进行加密，避免加密扩大化；
* **建议-2** 为了便于 `grep` 等文本检索工具检索所有被引用的变量定义，对于需要加密的变量建议使用一个 **中间变量** 来隔离 `被引用变量` 和 `加密数据`。

---

## 变量加密推荐做法实例 {id="var-encrypted-examples"}

```yaml
# group_vars/demo/vars.html
demo_group_name: "demo"
demo_users: 
  alice:
    group: "vault_group"
    passwd: "{{ vault_demo_users.alice.passwd }}"
  bob:
    group: "vault_group"
    passwd: "{{ vault_demo_users.bob.passwd }}"

# group_vars/demo/vault.html
# 该文件的实际内容使用 ansible-vault 加密存储
vault_demo_users:
  alice:
    passwd: "plz-change-me"
  bob:
    passwd: "plz-change-me"
```

# 项目结构

---

[Ansible 最佳实践](http://docs.ansible.com/ansible/latest/playbooks_best_practices.html)

在官方推荐的 [目录布局](http://docs.ansible.com/ansible/latest/playbooks_best_practices.html#directory-layout) 基础之上，进一步精简一个常用目录组织结构：

```yaml
production                # 生产环境服务器清单文件
staging                   # 模拟环境服务器清单文件

group_vars/
   group1                 # here we assign variables to particular groups
   group2                 # ""
host_vars/
   hostname1              # if systems need specific variables, put them here
   hostname2              # ""

site.yml                  # master playbook
webservers.yml            # playbook for webserver tier
dbservers.yml             # playbook for dbserver tier

roles/
    common/               # this hierarchy represents a "role"
        tasks/            #
            main.yml      #  <-- tasks file can include smaller files if warranted
        handlers/         #
            main.yml      #  <-- handlers file
        templates/        #  <-- files for use with the template resource
            ntp.conf.j2   #  <------- templates end in .j2
        files/            #
            bar.txt       #  <-- files for use with the copy resource
            foo.sh        #  <-- script files for use with the script resource
        vars/             #
            main.yml      #  <-- variables associated with this role
        defaults/         #
            main.yml      #  <-- default lower priority variables for this role
        meta/             #
            main.yml      #  <-- role dependencies

    webtier/              # same kind of structure as "common" was above, done for the webtier role
    monitoring/           # ""
    fooapp/               # ""
```

# 参考资料

---

* [Cheatsheet of Ansible](http://cheat.readthedocs.io/en/latest/ansible/)
* [An Ansible summary Jon Warbrick, July 2014, V3.2 (for Ansible 1.7)](https://gist.github.com/andreicristianpetcu/b892338de279af9dac067891579cad7d)

