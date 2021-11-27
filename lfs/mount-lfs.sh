#!/bin/bash

source ./utils.sh

check_environment true

echo "Mounting LFS partition '${LFS_PARTITION}' on '${LFS}'"
sudo mkdir -pv "${LFS}"
sudo mount -v -t ext4 "${LFS_PARTITION}" "${LFS}"
echo "DONE"
echo