#!/bin/bash
echo "Setting locale..."
sed -i "s/#en_US/en_US/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting local time..."
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

echo "Setting system clock..."
hwclock --systohc --utc

echo "Enter the computer name, followed by [ENTER]:"
read computername
echo $computername > /etc/hostname
sed -i "s/localhost/localhost $computername/g" /etc/hosts

echo "Set the root password"
passwd

echo "Install zshell"
pacman -S install zsh

echo "Enter user name, followed by [ENTER]:"
read username
useradd -m -g users -G wheel,storage,power -s /bin/zsh $username

echo "Set user password"
passwd $username

echo "Installing bootloader (rEFInd)"
pacman -S refind-efi
refind-install

echo "Preparing boot image"
mkinitcpio -p linux

echo "Configuration complete! Exiting..."