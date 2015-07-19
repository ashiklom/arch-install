#!/bin/sh
# Partition disk using parted
echo "Enter disk name, followed by [ENTER]:"
read disk

parted -s /dev/sda mklabel msdos
parted -s /dev/sda mkpart primary ext4 1MiB 100%
parted -s /dev/sda set 1 boot on

sleep 2

mkfs.ext4 /dev/sda1

# Mount partitions
echo "Mounting partitions"
mount /dev/sda1 /mnt

sleep 2

echo "Done partitioning! Proceed with arch-install.sh"
