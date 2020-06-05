
## 快速上手

参考 [第一章 实验报告](../../../../chap0x01.exp.md) 里的方法去构建「无人值守」安装镜像。

> ⚠️ 重要提醒⚠️

在使用虚拟化技术制作「基础镜像」时，[强烈建议清空 `/etc/machine-id` 内容](../../../../cloud-init.md#为什么需要重置-machine-id-idwhy-reset-machine-id) 后，再关机制作「基础镜像」。

## cloud-init.seed VS. ubuntu-server-autoinstall.seed

|              | cloud-init.seed           | ubuntu-server-autoinstall.seed |
| :--          | :--                       | :--                            |
| 语言选项     | en_US.UTF-8               | en_US.UTF-8, zh_CN.UTF-8       |
| 网络自动配置 | 已开启                    | 禁用，静态配置                 |
| 主机名设置   | cloud-init-svr            | isc-vm-host                    |
| LVM 配置     | 单分区模式                | 多分区模式                     |
| APT 网络镜像 | 已启用                    | 禁用                           |
| 预安装软件   | openssh-server cloud-init | openssh-server                 |


