#!/bin/bash

echo "Set up mirror list"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
curl -O https://raw.githubusercontent.com/Gen2ly/armrr/master/armrr
chmod +x armrr
./armrr US

echo "Installing Arch"
pacstrap -i /mnt base base-devel

sleep 5

echo "Generating fstab file"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "Running arch configuration script..."
cp arch-configure.sh /mnt/home/arch-configure.sh
chmod +x /mnt/home/arch-configure.sh
arch-chroot /mnt /home/arch-configure.sh

echo "Installation complete! Exiting and rebooting..."
sleep 5
umount -R /mnt
reboot
