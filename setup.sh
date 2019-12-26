#!/bin/bash

set -e

SCRIPTPATH="$( cd "$(dirname "$0")" && pwd -P )"

echo "--> Setup"
rm -rf ~/.vimrc
rm -rf ~/.vim
rm -rf ~/.zshrc*
rm -rf ~/.oh-my-zsh
mkdir -p ~/go
mkdir -p ~/.vim/undo

echo "--> Install Homebrew"
if ! command -v brew; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew bundle install --file="$SCRIPTPATH/Brewfile"

echo "--> Install OhMyZsh"
echo "Please run 'exit' at the end."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "--> Link dotfiles"
(
    cd $HOME
    dotfiles=(bashrc gitconfig gitignore_global npmrc vimrc zshrc)
    for f in "${dotfiles[@]}"; do
        echo "~/.$f"
        ln -sf "$SCRIPTPATH/dotfiles/.$f" ".$f"
    done

    mkdir -p ~/.oh-my-zsh/themes && cd ~/.oh-my-zsh/themes
    ln -sf "$SCRIPTPATH/dotfiles/.oh-my-zsh/themes/dethi.zsh-theme" dethi.zsh-theme
)

echo "--> Install Vundle"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

echo "--> Configure YouCompleteMe..."
(
    cd ~/.vim/bundle/YouCompleteMe
    ./install.py
)

echo "--> Done"