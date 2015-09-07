#!/bin/bash

set -e

SCRIPTPATH="$HOME/Documents/Git/all"
GETPIP="https://bootstrap.pypa.io/get-pip.py"
HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
OHMYZSH="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

# Ask for the sudo password
sudo echo "Thanks."

if [ $(uname) = "Darwin" ]; then
    echo "Setup Mac installation..."

    echo | ruby -e "$(curl -fsSL $HOMEBREW)"

    brew update
    brew install wget git zsh macvim go python cmake
else
    echo "Setup Linux configuration..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl git zsh vim golang python \
        python-dev build-essential cmake

    wget $GETPIP -O - | sudo python
fi

echo "Upgrade PIP..."
sudo pip install --upgrade pip setuptools
sudo pip install --upgrade flake8 virtualenv

echo "Clone dotfiles repository..."
(
    git clone https://github.com/dethi/all.git $SCRIPTPATH

    # Little hack to clone the repository without my SSH key and then
    # reset origin to use SSH because I hate writing my username/password
    cd $SCRIPTPATH
    git remote set-url origin git@github.com:dethi/all.git
)

echo "Install OhMyZsh"
TMP="/tmp/com.github.dethi.all.ohmyzsh-install.sh"
wget $OHMYZSH -O "$TMP.bak"
# Remove the last two lines, so the installation can continue
awk -v n=2 'NR>n{print line[NR%n]};{line[NR%n]=$0}' "$TMP.bak" > $TMP
sh $TMP
rm -f $HOME/.zshrc

echo "Generate links..."
(
    cd $HOME
    mkdir -p $HOME/Documents/gocode

    ln -s "$SCRIPTPATH/dotfiles/.gitconfig" .gitconfig
    ln -s "$SCRIPTPATH/dotfiles/.gitignore_global" .gitignore_global
    ln -s "$SCRIPTPATH/dotfiles/.vimrc" .vimrc
    ln -s "$SCRIPTPATH/dotfiles/.zprofile" .zprofile
    ln -s "$SCRIPTPATH/dotfiles/.zshrc" .zshrc

    mkdir -p $HOME/.vim/colors && cd $HOME/.vim/colors
    ln -s "$SCRIPTPATH/dotfiles/.vim/colors/distinguished.vim" distinguished.vim

    mkdir -p $HOME/.oh-my-zsh/themes && cd $HOME/.oh-my-zsh/themes
    ln -s "$SCRIPTPATH/dotfiles/.oh-my-zsh/themes/dethi.zsh-theme" dethi.zsh-theme
)

echo "Install Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "Configure YouCompleteMe..."
python $HOME/.vim/bundle/YouCompleteMe/install.py --clang-completer \
    --gocode-completer

echo "Download Go Binaries..."
export GOPATH="$HOME/Documents/gocode"
export PATH="$HOME/Documents/gocode/bin:$PATH"
vim +GoInstallBinaries +qall

echo "Done :)"
