#!/bin/bash

echo "Setting pacman mirror"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
echo 'Server = http://mirror.umd.edu/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist

echo "Installing Arch"
pacstrap -i /mnt base base-devel

sleep 5

echo "Generating fstab file"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "Running arch configuration script..."
cp > arch-configure.sh /mnt/home/arch-configure.sh
chmod +x /mnt/home/arch-configure.sh
arch-chroot /mnt /home/arch-configure.sh

echo "Generating boot file"
sed -i "/^HOOKS=/ s/block filesystems/block lvm2 filesystems/g" /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "Installation complete! Exiting and rebooting..."
sleep 5
umount -R /mnt
reboot