#!/usr/bin/env bash

# VBoxManage list ostypes

# VBoxManage list groups
## "/Linux"
## "/Windows"

# VBoxManage showvminfo "ansible-slave-1"

vm_name="${1:-ansible-slave-1}"
vdi_base="${2:-$HOME/vdi_base/ub18.04.4-lvm.vdi}"
ci_iso="${3:-$HOME/VirtualBox VMs/init-ansible.iso}"

error=0

function usage() {
  echo "Usage: bash $0 <new-vm-name> <vdi_path> <cidata.iso> "
  echo "<new-vm-name> 虚拟机名称"
  echo "<vdi_path>    使用已有的虚拟硬盘文件"
  echo "<cidata.iso>  光驱挂载包含 cloud-init 数据的 iso 文件"
  return
}

if [[ $(VBoxManage list vms | cut -d ' ' -f 1 | grep -w "\"$vm_name\"" -c) -gt 0 ]];then
  echo "vm $vm_name exsits, ignore and exit"
  error=$((error+1))
fi

if [[ ! -f "$vdi_base" ]];then
  echo "$vdi_base does not exist"
  error=$((error+1))
fi

vdi_name=$(basename -- "$vdi_base")
vdi_ext="${vdi_name##*.}"

if [[ "$vdi_ext" != "vdi" ]];then
  echo "$vdi_base is not a vdi file"
  error=$((error+1))
fi

if [[ ! -f "$ci_iso" ]];then
  echo "$ci_iso does not exist"
  error=$((error+1))
fi

iso_name=$(basename -- "$ci_iso")
iso_ext="${iso_name##*.}"

if [[ "$iso_ext" != "iso" ]];then
  echo "$ci_iso is not a iso file"
  error=$((error+1))
fi


if [[ $error -gt 0 ]];then
  usage
  exit $error
fi

# 创建一个虚拟机
## --name 虚拟机名称
## --ostype 操作系统类型：Oracle (64-bit)
## --register 注册到虚拟机管理器
## --groups 将虚拟机编入分组 Linux
VBoxManage createvm --name "$vm_name" --ostype Oracle_64 --register --groups "/Linux"

# 创建一个 IDE 控制器
VBoxManage storagectl "$vm_name" --name "IDE Controller" --add ide
# 向该控制器安装一个「光驱」
VBoxManage storageattach "$vm_name" --storagectl "IDE Controller" --port 0 \
  --device 0 --type dvddrive --medium "$ci_iso" 

# 创建一个 SATA 控制器
VBoxManage storagectl "$vm_name" --name "SATA Controller" --add sata --controller IntelAHCI
# 向该控制器安装一个「硬盘」
## --medium 指定本地的一个「多重加载」虚拟硬盘文件
VBoxManage storageattach "$vm_name" --storagectl "SATA Controller" --port 0 \
  --device 0 --type hdd --medium "$vdi_base"

# 修改虚拟机配置
## --memory 内存设置为 1024MB
## --vram   显存设置为 16MB
VBoxManage modifyvm "$vm_name" --memory 1024 --vram 16

# ref: https://docs.oracle.com/en/virtualization/virtualbox/6.1/user/settings-display.html
# VMSVGA: Use this graphics controller to emulate a VMware SVGA graphics device. This is the default graphics controller for Linux guests.
VBoxManage modifyvm "$vm_name" --graphicscontroller vmsvga

# 查看所有 Host-Only 网络
# VBoxManage list hostonlyifs

## 添加 Host-Only 网卡为第 2 块虚拟网卡
## --nictype2 第 2 块网卡的控制芯片为 Intel PRO/1000 MT 桌面 (82540EM)
## --hostonlyadapter2 第 2 块网卡的界面名称为 vboxnet0
VBoxManage modifyvm "$vm_name" --nic2 "hostonly" --nictype2 "82540EM" --hostonlyadapter2 "vboxnet0"

