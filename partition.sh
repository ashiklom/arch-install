#!/bin/sh
# Partition disk using sgdisk
echo "Enter disk name, followed by [ENTER]:"
read disk

echo "Creating base partitions"
sgdisk -z $disk     # Wipe (zap) the current partition table
sgdisk -og $disk    # Create a new GPT partition table

# Set up the start and end positions of the different partitions
start1=2048
start2=$((start1 + 512*2048))
end1=$((start2-1))
end2=`sgdisk -E $disk`

# Create the partitions
sgdisk -n 1:$start1:$end1 -c 1:"EFI System Boot" -t 1:ef00 $disk
mkfs.vfat -F32 /dev/sda1
sgdisk -n 2:$start2:$end2 -c 2:"Linux LVM" -t 2:8e00 $disk

# List partitions on /dev/sda
fdisk /dev/sda -l

sleep 2

# Create logical volumes
echo "Creating logical volumes"
pvcreate -ff /dev/sda2
vgcreate lvm /dev/sda2
lvcreate -l 50%FREE lvm -n arch
mkfs.ext4 /dev/lvm/arch
lvcreate -l 100%FREE lvm -n home
mkfs.ext4 /dev/lvm/home
lvdisplay

sleep 2

echo "Done partitioning! Proceed with arch-install.sh"
