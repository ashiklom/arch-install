#!/bin/bash
# Post-installation configuration of Arch

username=$(1:-"ashiklom")

# Other important packages
sudo -u $username pacman -S --noconfirm git openssh \
    ruby r gcc-fortran \
    python python2 python-pip \
    ttf-ubuntu-font-family

echo "Installing yaourt for AUR packages"
mkdir /home/$username/builds & cd /home/$username/builds
aur='https://aur.archlinux.org/packages'
wget "$aur/pa/package-query/package-query.tar.gz"
tar xvf package-query.tar.gz
cd package-query
makepkg -s --asroot
packagename=`find . -name *.pkg.tar.xz`
sudo -u $username pacman -U $packagename
cd ..
wget $aur/ya/yaourt/yaourt.tar.gz
tar xvf yaourt.tar.gz
cd yaourt
makepkg -s --asroot
packagename=`find . -name *.pkg.tar.xz`
sudo -u $username pacman -U $packagename
cd /home/$username

echo "Installing AUR packages"
yaourt -S neovim-git --noconfirm

echo "Downloading user files"
git clone https://github.com/ashiklom/my_vim ~/.vim
ln -s ~/.vim ~/.nvim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vimrc ~/.nvimrc
git clone https://github.com/ashiklom/dotfiles
ln -s ~/dotfiles/fluxbox ~/.fluxbox
ln -s ~/dotfiles/Xresources/main ~/.Xresources
