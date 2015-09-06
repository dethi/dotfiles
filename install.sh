#!/bin/bash

set -e

SCRIPTPATH="~/Documents/Git/all"
GETPIP="https://bootstrap.pypa.io/get-pip.py"
HOMEBREW="https://raw.githubusercontent.com/Homebrew/install/master/install"
OHMYZSH="https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh"

cecho() {
	# Colorized echo
    printf "\e[0;32m%s\e[0m\n" "$1"
}

# Ask for the sudo password
sudo echo "Thanks."

if [ $(uname) = "Darwin" ]; then
    cecho "Setup Mac installation..."

    echo | ruby -e "$(curl -fsSL $HOMEBREW)"

    brew update
    brew install wget git zsh macvim go python
else
    cecho "Setup Linux configuration..."

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y curl git zsh vim golang python \
        python-dev build-essential

    wget $GETPIP -O - | sudo python
fi

cecho "Upgrade PIP..."
sudo pip install --upgrade pip setuptools
sudo pip install --upgrade flake8 virtualenv

cecho "Clone dotfiles repository..."
(
    mkdir -p ~/Documents/Git
    cd ~/Documents/Git
    git clone https://github.com/dethi/all.git

    # Little hack to clone the repository without my SSH key and then
    # reset origin to use SSH because I hate writing my username/password
    cd all
    git remote set-url origin git@github.com:dethi/all.git
)

cecho "Install OhMyZsh"
TMP="/tmp/com.github.dethi.all.ohmyzsh-install.sh"
wget $OHMYZSH -O "$TMP.bak"
# Remove the last two lines, so the installation can continue
awk -v n=2 'NR>n{print line[NR%n]};{line[NR%n]=$0}' "$TMP.bak" > $TMP
sh $TMP
rm -f ~/.zshrc

echo "Generate links..."
ln "$SCRIPTPATH/dotfiles/.gitconfig" ~/.gitconfig
ln "$SCRIPTPATH/dotfiles/.gitignore_global" ~/.gitignore_global
ln "$SCRIPTPATH/dotfiles/.vimrc" ~/.vimrc
ln "$SCRIPTPATH/dotfiles/.zprofile" ~/.zprofile
ln "$SCRIPTPATH/dotfiles/.zshrc" ~/.zshrc

mkdir -p ~/.vim/colors
ln "$SCRIPTPATH/dotfiles/.vim/colors/distinguished.vim" \
    ~/.vim/colors/distinguished.vim

mkdir -p ~/.oh-my-zsh/themes
ln "$SCRIPTPATH/.oh-my-zsh/themes/dethi.zsh-theme" \
    ~/.oh-my-zsh/themes/dethi.zsh-theme

cecho "Install Vundle..."
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
vim +GoInstallBinaries +qall

cecho "Configure YouCompleteMe..."
python ~/.vim/bundle/YouCompleteMe/install.py \
    --clang-completer --gocode-completer

cecho "Done :)"
