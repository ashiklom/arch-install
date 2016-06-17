#!/bin/sh
# Partition disk using sgdisk
echo "Enter disk name, followed by [ENTER]:"
read disk

echo "Creating partitions to emulate current computer"
parted -s $disk \
    mklabel gpt \
    mkpart primary ntfs 1049kB 315MB \
    set 1 hidden on \
    set 1 diag on\
    mkpart ESP fat32 316MB 419MB \
    set 2 boot on \
    mkpart primary fat32 419MB 554MB \
    mkpart primary ntfs 554MB 560MB \
    mkpart primary ext4 560MB 100% \
    print

# Make file systems on relevant partitions
mkfs.vfat -F32 /dev/sda2
mkfs.ext4 /dev/sda6

# List partitions on /dev/sda
fdisk /dev/sda -l

sleep 2

# Mount partitions
echo "Mounting partitions"
mount /dev/sda5 /mnt
mkdir /mnt/home /mnt/boot
mount /dev/sda5 /mnt/home
mount /dev/sda2 /mnt/boot

sleep 2

echo "Done partitioning! Proceed with arch-install.sh"
