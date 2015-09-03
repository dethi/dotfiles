# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"
plugins=(git osx brew extract jump docker docker-compose sudo)

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR='vim'

# Path
export PATH=$HOME/Dropbox/Scripts:$PATH # Dropbox script
export PATH=$PATH:/usr/local/opt/go/libexec/bin # Go

# Alias
alias avenv="source ./env/bin/activate"
alias rmpyc="find . -type f -name \"*.pyc\" -delete"

# Env file
if [ -f $HOME/.env ]; then
    source $HOME/.env
fi
