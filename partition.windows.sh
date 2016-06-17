#!/bin/sh
# Partition disk using sgdisk
echo "Enter disk name, followed by [ENTER]:"
read disk

echo "Creating partitions to emulate current computer"
sgdisk -z $disk     # Wipe (zap) the current partition table
sgdisk -og $disk    # Create a new GPT partition table

start1=2048
end1=616447
start2=616448
end2=819199
start3=819200
end3=1081343
start4=1081344
end4=$((start4 + 2048))
start5=$((end4 + 1))
end5=$((start5 + 2048))
start6=$((end5 + 1))
end6=`sgdisk -E $disk`

# Create the partition table
sgdisk -n 1:$start1:$end1 -c 1:"Windows recovery environment" -t 1:2700 $disk
sgdisk -n 2:$start2:$end2 -c 1:"EFI system partition" -t 1:ef00 $disk
sgdisk -n 3:$start3:$end3 -c 1:"Microsoft reserved" -t 1:0c01 $disk
sgdisk -n 4:$start4:$end4 -c 1:"Windows" -t 1:0700 $disk
sgdisk -n 5:$start5:$end5 -c 1:"Windows recovery" -t 1:2700 $disk
sgdisk -n 6:$start6:$end6 -c 1:"Linux" -t 1:0700 $disk

sleep 2

# Make file systems on relevant partitions
mkfs.vfat -F32 /dev/sda2
mkfs.ext4 /dev/sda6

# List partitions on /dev/sda
fdisk /dev/sda -l

sleep 2

# Mount partitions
echo "Mounting partitions"
mount /dev/sda6 /mnt
mkdir /mnt/home /mnt/boot
mount /dev/sda6 /mnt/home
mount /dev/sda2 /mnt/boot

sleep 2

echo "Done partitioning! Proceed with arch-install.sh"
