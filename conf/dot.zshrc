# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"
plugins=(git osx brew jump)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR='vim'
export PATH=$HOME/Dropbox/Scripts:$PATH:/usr/local/opt/go/libexec/bin

# Alias
alias avenv="source ./env/bin/activate"
alias mgzip="tar --use-compress-program=pigz -cvf"
alias mbzip2="tar --use-compress-program=pbzip2 -cvf"
