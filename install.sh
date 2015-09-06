#!/bin/bash

set -e

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
OHMYZSH="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

# Ask for the sudo password
sudo echo "Thanks."

if [ $(uname) = "Darwin" ]; then
    echo "Setup Mac installation..."

    # Homebrew
    echo | ruby -e "$(curl -fsSL $HOMEBREW)"

    brew update
    brew install wget git zsh macvim go python
else
    echo "Setup Linux configuration..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl git zsh vim golang python \
        python-dev-all build-essential

    # PIP
    wget https://bootstrap.pypa.io/get-pip.py -O - | python
fi

mkdir -p ~/Documents/Git
git clone https://github.com/dethi/all.git ~/Documents/Git/all

pip install --upgrade pip setuptools
pip install --upgrade flake8 virtualenv

# OhMyZsh
sh -c "$(curl -fsSL $OHMYZSH)"

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
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

# Configure YouCompleteMe
python ~/.vim/bundle/YouCompleteMe/install.py \
    --clang-completer --gocode-completer
