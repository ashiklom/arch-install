#!/bin/bash
echo "Setting locale..."
sed -i "s/#en_US/en_US/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting local time..."
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

echo "Setting system clock..."
hwclock --systohc --utc

echo "Enabling networking..."
systemctl enable dhcpcd@enp0s3.service

echo "Enter the computer name, followed by [ENTER]:"
read computername
echo $computername > /etc/hostname
sed -i "s/localhost/localhost $computername/g" /etc/hosts

echo "Set the root password"
passwd

echo "Setting sudo permissions for 'wheel' group"
sed -i "0,/# %wheel/{s/# %wheel/%wheel/}"

echo "Install command line tools"
pacman -S --noconfirm zsh vim wget

echo "Enter user name, followed by [ENTER]:"
read username
useradd -m -g users -G wheel,storage,power -s /bin/zsh $username

echo "Set user password"
passwd $username

echo "Setting up GUI"
pacman -S --noconfirm xorg-server xorg-init fluxbox virtualbox-guest-utils rxvt-unicode
echo "vboxguest\nvboxsf\nvboxvideo" > /etc/modules-load.d/virtualbox.conf
cp xinitrc /home/ashiklom/.xinitrc
fluxbox-generate-menu

echo "Installing bootloader (grub)"
pacman -S --noconfirm grub
grub-install --recheck /dev/sda

echo "Generating boot file"
mkinitcpio -p linux

echo "Configuration complete! Exiting..."
