#!/usr/bin/env bash

box="bionic-server-cloudimg-amd64-vagrant.box"
box_sum="sha256.sum"

function vagrant_up() {
  if [[ $(shasum -a 256 -c "${box_sum}") ]];then
    vagrant up 
  else
    echo "$box is corrupted, plz download it agagin."
  fi
  return $?
}

if [[ -f "$box" && -f "${box_sum}" ]];then
  vagrant_up
  ret=$?
fi

if [[ -z $ret || $ret -ne 0 ]];then
  wget "https://mirror.tuna.tsinghua.edu.cn/ubuntu-cloud-images/bionic/current/$box"
  wget https://mirror.tuna.tsinghua.edu.cn/ubuntu-cloud-images/bionic/current/SHA256SUMS
  grep bionic-server-cloudimg-amd64-vagrant.box SHA256SUMS > "${box_sum}"
  vagrant_up
fi

