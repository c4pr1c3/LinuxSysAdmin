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


