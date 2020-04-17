#!/usr/bin/env bash

# VBoxManage guestproperty enumerate "$vm_name"
# VBoxManage guestproperty enumerate ub18.04.4-lvm | sed -rn "s/.*\/VirtualBox\/GuestInfo\/Net\/([0-9]+)\/[V4\/]*[IP|MAC]+, value: ([A-Z0-9.]+).*/\1 \2/p"

# 虚拟机内需要安装客户机增强功能套件 
# sudo apt install virtualbox-guest-utils

vm_name="${1:-ub18.04.4-lvm}"

for i in $(seq 0 3);do
  mac=$(VBoxManage guestproperty get "$vm_name" "/VirtualBox/GuestInfo/Net/$i/MAC" | cut -d ' ' -f 2)
  ip=$(VBoxManage guestproperty get "$vm_name" "/VirtualBox/GuestInfo/Net/$i/V4/IP" | cut -d ' ' -f 2)
  netmask=$(VBoxManage guestproperty get "$vm_name" "/VirtualBox/GuestInfo/Net/$i/V4/Netmask" | cut -d ' ' -f 2)
  if [[ "$mac" != "value" ]];then
    printf "iface %d %s %s %s\n" "$i" "$mac" "$ip" "$netmask"
  fi
done
