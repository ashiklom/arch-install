#!/bin/bash

echo "Set up mirror list"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
curl -O https://raw.githubusercontent.com/Gen2ly/armrr/master/armrr
chmod +x armrr
./armrr US

echo "Installing Arch"
# NOTE: The `-i` flag makes this interactive.
pacstrap /mnt base base-devel

sleep 5

echo "Generating fstab file"
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "Running arch configuration script..."
cp arch-configure.sh post-install.sh xinitrc /mnt/home
chmod +x /mnt/home/arch-configure.sh /mnt/home/post-install.sh
arch-chroot /mnt /home/arch-configure.sh
arch-chroot /mnt /home/post-install.sh

echo "Installation complete! Exiting and rebooting..."
sleep 5
umount -R /mnt
reboot
