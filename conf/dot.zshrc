# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"
plugins=(git osx brew extract jump)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'

# Path
export PATH=$HOME/Dropbox/Scripts:$PATH # Dropbox script
export PATH=$PATH:/usr/local/sbin # For mtr...
export PATH=$PATH:/usr/local/opt/go/libexec/bin # Go
export PATH=$PATH:$HOME/.rvm/bin # RVM

# Alias
alias avenv="source ./env/bin/activate"
alias mgzip="tar --use-compress-program=pigz -cvf"
alias mbzip2="tar --use-compress-program=pbzip2 -cvf"

# Env file
if [ -f $HOME/.env ]; then
    source $HOME/.env
fi
