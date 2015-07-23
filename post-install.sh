#!/bin/bash
# Post-installation configuration of Arch

username=$(1:-"ashiklom")

# Other important packages
sudo -u $username `pacman -S --noconfirm git openssh \
    ruby r gcc-fortran tmux \
    python python2 python-pip \
    ttf-ubuntu-font-family ttf-inconsolata`

echo "Installing yaourt for AUR packages"
mkdir ~/builds & cd ~/builds
aur='https://aur.archlinux.org/packages'
wget "$aur/pa/package-query/package-query.tar.gz"
tar xvf package-query.tar.gz
cd ~/builds/package-query
makepkg -s
packagename=`find . -name *.pkg.tar.xz`
sudo -u $username `pacman -U $packagename`
cd ~/builds
wget $aur/ya/yaourt/yaourt.tar.gz
tar xvf yaourt.tar.gz
cd ~/builds/yaourt
makepkg -s
packagename=`find . -name *.pkg.tar.xz`
sudo -u $username `pacman -U $packagename`
cd ~

echo "Installing AUR packages"
yaourt -S neovim-git --noconfirm

echo "Downloading and setting up user files"
git clone git@github.com:ashiklom/my_vim ~/.vim
ln -s ~/.vim ~/.nvim
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vimrc ~/.nvimrc
vim +PlugInstall +qall now
git clone git@github.com:ashiklom/dotfiles
ln -s ~/dotfiles/fluxbox ~/.fluxbox
ln -s ~/dotfiles/Xresources/main ~/.Xresources
ln -s ~/dotfiles/xinitrc ~/.xinitrc
ln -s ~/dotfiles/fluxbox ~/.fluxbox
~/dotfiles/setup.prezto.sh
