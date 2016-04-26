#!/bin/bash

set -e

ME="tinux"
SCRIPTPATH="$HOME/Documents/Git/all"
GETPIP="https://bootstrap.pypa.io/get-pip.py"
HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"

# Ask for the sudo password
sudo echo "--> Thanks."

if [ $(uname) = "Darwin" ]; then
    echo "--> Setup Mac installation..."

    echo | ruby -e "$(curl -fsSL $HOMEBREW)"

    brew update
    brew install $(cat package.lst)

    brew tap caskroom/cask
    brew cask install java
else
    echo "--> Setup Linux configuration..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl git zsh vim golang python \
        python-dev build-essential cmake gdb valgrind

    wget $GETPIP -O - | sudo python
fi

echo "--> Upgrade PIP..."
sudo pip install --upgrade pip setuptools
sudo pip install --upgrade flake8 virtualenv

echo "--> Clean some directories..."
rm -rf $SCRIPTPATH
rm -rf $HOME/.vimc
rm -rf $HOME/.oh-my-zsh

echo "--> Clone dotfiles repository..."
(
    git clone https://github.com/dethi/all.git $SCRIPTPATH

    # Little hack to clone the repository without my SSH key and then
    # reset origin to use SSH because I hate writing my username/password
    if [ $USER = $ME ]; then
        cd $SCRIPTPATH
        git remote set-url origin git@github.com:dethi/all.git
    fi
)

echo "--> Install OhMyZsh"
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
chsh -s $(grep /zsh$ /etc/shells | tail -1)

echo "--> Generate links..."
(
    cd $HOME
    mkdir -p $HOME/Documents/gocode
    mkdir -p $HOME/.vim/undo

    if [ $USER = $ME ]; then
        ln -sf "$SCRIPTPATH/dotfiles/.gitconfig" .gitconfig
        ln -sf "$SCRIPTPATH/dotfiles/.gitignore_global" .gitignore_global
    else
        echo "/!\ Please configure your ~/.gitconfig file!"
    fi

    ln -sf "$SCRIPTPATH/dotfiles/.vimrc" .vimrc
    ln -sf "$SCRIPTPATH/dotfiles/.zprofile" .zprofile
    ln -sf "$SCRIPTPATH/dotfiles/.zshrc" .zshrc

    mkdir -p $HOME/.oh-my-zsh/themes && cd $HOME/.oh-my-zsh/themes
    ln -sf "$SCRIPTPATH/dotfiles/.oh-my-zsh/themes/dethi.zsh-theme" dethi.zsh-theme
)

echo "--> Install Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "--> Configure YouCompleteMe..."
python $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer \
    --gocode-completer

echo "--> Download Go Binaries..."
export GOPATH="$HOME/Documents/gocode"
export PATH="$HOME/Documents/gocode/bin:$PATH"
vim +GoInstallBinaries +qall

echo "--> Done :)"
