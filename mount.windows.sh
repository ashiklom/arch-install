#!/bin/bash

# Mount partitions
echo "Mounting partitions"
mount /dev/sda5 /mnt
mkdir /mnt/home /mnt/boot
mount /dev/sda5 /mnt/home
mount /dev/sda2 /mnt/boot

sleep 2

