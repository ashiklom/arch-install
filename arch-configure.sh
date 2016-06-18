#!/bin/bash
echo "Setting locale..."
sed -i "s/#en_US/en_US/g" /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "Setting local time..."
ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

echo "Setting system clock..."
hwclock --systohc --utc

#echo "Enter the computer name, followed by [ENTER]:"
#read computername
computername="arch_vm"
echo $computername > /etc/hostname
sed -i "s/localhost/localhost $computername/g" /etc/hosts

echo "Set the root password"
passwd

# Install packages
    #xf86-video-intel mesa lib32-mesa-libgl intel-ucode \
    #gnome gnome-extra \
pacman -S --noconfirm \
    xf86-video-vesa \
    git vim \
    iw wpa_supplicant dialog \
    xorg-server xorg-utils xorg-xinit xterm \
    lightdm-gtk-greeter \
    fluxbox \
    refind-efi \
    tlp

#echo "Enter user name, followed by [ENTER]:"
#read username
username="ashiklom"
useradd -m -g users -G wheel,storage,power -s /bin/zsh $username

# Allow 'whell' group to use sudo
./edit.sudoers.sh

echo "Set user password"
passwd $username

# Enable desktop greeter
systemctl enable lightdm.service

# Instlal refind boot manager
refind-install

echo "Configuring network"
# Set hostname
echo "ashiklom-arch_vm" > /etc/hostname
ethernet_dev=`ip link | grep -P -o "(?<= )en.*(?=:)"`
wireless_dev=`ip link | grep -P -o "(?<= )wl.*(?=:)"`
systemctl enable dhpcd@${ethernet_dev}.service
systemctl start dhpcd@${ethernet_dev}.service

echo "Generating boot file"
#sed -i "/^HOOKS=/ s/block filesystems/block lvm2 filesystems/g" /etc/mkinitcpio.conf
mkinitcpio -p linux

echo "Configuration complete! Exiting..."
