#!/bin/bash
# Post-installation configuration of Arch

username=ashiklom

# Other important packages
pacman -S --noconfirm git openssh \
    ruby r gcc-fortran \
    python python2 python-pip

echo "Installing yaourt for AUR packages"
mkdir /home/$username/builds & cd /home/$username/builds
aur='https://aur.archlinux.org/packages'
wget $aur/pa/package-query/package-query.tar.gz
tar xvf package-query.tar.gz
cd package-query
makepkg -s --asroot
packagename=`find . -name *.pkg.tar.xz`
pacman -U $packagename
cd ..
wget $aur/ya/yaourt/yaourt.tar.gz
tar xvf yaourt.tar.gz
cd yaourt
makepkg -s --asroot
packagename=`find . -name *.pkg.tar.xz`
pacman -U $packagename
cd

echo "Installing AUR packages"
yaourt -S neovim --noconfirm

echo "Downloading user files"
git clone https://github.com/ashiklom/my_vim ~/.vim
ln -s ~/.vim ~/.nvim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vimrc ~/.nvimrc
git clone https://github.com/ashiklom/dotfiles
ln -s ~/dotfiles/fluxbox ~/.fluxbox
ln -s ~/dotfiles/Xresources/main ~/.Xresources
