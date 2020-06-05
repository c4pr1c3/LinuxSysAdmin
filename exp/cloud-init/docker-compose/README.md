## 基本功能

在 `Ubuntu 18.04` 中自动安装 `Docker` 和 `docker-compose` ，使用了清华大学的 `docker` 和 `pip` 镜像源。

## 安装依赖工具

```bash
# ubuntu
sudo apt install genisoimage

# mac
brew install cdrtools
```

## 创建 cloud-init 镜像

```bash
# ubuntu
genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data

# mac
mkisofs -output init.iso -volid cidata -joliet -rock user-data meta-data
```

### 网络配置

`network-config` 里定义了 `net-plan` 兼容的[网卡配置](https://cloudinit.readthedocs.io/en/latest/topics/network-config-format-v2.html) 。

根据[官方文档说明](https://cloudinit.readthedocs.io/en/latest/topics/datasources/nocloud.html)，文件名同样不能修改，必须是 `network-config` ：

> Network configuration can also be provided to cloud-init in either Networking Config Version 1 or Networking Config Version 2 by providing that yaml formatted data in a file named `network-config`. If found, this file will override a network-interfaces file.

```bash
# ubuntu
genisoimage -output init.iso -volid cidata -joliet -rock user-data meta-data network-config

# mac
mkisofs -output init.iso -volid cidata -joliet -rock user-data meta-data network-config
```
