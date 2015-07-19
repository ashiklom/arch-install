#!/bin/sh
# Partition disk using parted
disk=$(1:-"/dev/sda")

parted -s $disk mklabel msdos
parted -s $disk mkpart primary ext4 1MiB 100%
parted -s $disk set 1 boot on

sleep 2

mkfs.ext4 "$disk""1"

# Mount partitions
echo "Mounting partitions"
mount /dev/sda1 /mnt

sleep 2

echo "Done partitioning! Proceed with arch-install.sh"
