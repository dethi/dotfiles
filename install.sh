#!/bin/bash

set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
OHMYZSH="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

function cecho() {
	# Colorized echo
    printf "\e[0;32m%s\e[0m\n" "$1"
}

# Ask for the sudo password
sudo cecho "Thanks."

if [ $(uname) = "Darwin" ]; then
    cecho "Setup Mac installation..."

    # Homebrew
    echo | ruby -e "$(curl -fsSL $HOMEBREW)"

    brew update
    brew install wget git zsh macvim go python
else
    cecho "Setup Linux configuration..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl git zsh vim golang python \
        python-dev build-essential

    wget https://bootstrap.pypa.io/get-pip.py -O - | sudo python
fi

cecho "Upgrade PIP..."
sudo pip install --upgrade pip setuptools
sudo pip install --upgrade flake8 virtualenv

cecho "Clone dotfiles repository..."
mkdir -p ~/Documents/Git
git clone https://github.com/dethi/all.git ~/Documents/Git/all
(
    # Little hack to clone the repository without my SSH key and then
    # reset origin to use SSH because I hate writing my username/password
    cd ~/Documents/Git/all
    git remote set-url origin git@github.com:dethi/all.git
)

# OhMyZsh
cecho "Install OhMyZsh"
wget $OHMYZSH -O /tmp/com.github.dethi.all.ohmyzsh-install.sh
# It removes the last line, ". ~/.zshrc", so the installation can continue
sed -i.tmp '$d' /tmp/com.github.dethi.all.ohmyzsh-install.sh
sh /tmp/com.github.dethi.all.ohmyzsh-install.sh

echo "Generate links..."
ln -s "$SCRIPTPATH/dotfiles/.gitconfig" ~/.gitconfig
ln -s "$SCRIPTPATH/dotfiles/.gitignore_global" ~/.gitignore_global
ln -s "$SCRIPTPATH/dotfiles/.vimrc" ~/.vimrc
ln -s "$SCRIPTPATH/dotfiles/.zprofile" ~/.zprofile
ln -s "$SCRIPTPATH/dotfiles/.zshrc" ~/.zshrc

mkdir -p ~/.vim/colors
ln -s "$SCRIPTPATH/dotfiles/.vim/colors/distinguished.vim" \
    ~/.vim/colors/distinguished.vim

mkdir -p ~/.oh-my-zsh/themes
ln -s "$SCRIPTPATH/.oh-my-zsh/themes/dethi.zsh-theme" \
    ~/.oh-my-zsh/themes/dethi.zsh-theme

# Vundle
cecho "Install Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

# Configure YouCompleteMe
cecho "Configure YouCompleteMe..."
python ~/.vim/bundle/YouCompleteMe/install.py \
    --clang-completer --gocode-completer

cecho "Done :)"
