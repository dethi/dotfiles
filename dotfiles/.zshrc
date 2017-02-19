# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"

plugins=(git extract jump docker golang sudo)
if [ $(uname) = "Darwin" ]; then
    plugins+=(osx brew)
fi

source $ZSH/oh-my-zsh.sh

export EDITOR="vim"
export GOPATH="$HOME/go"

# Alias
alias avenv="source ./env/bin/activate"
alias rmpyc="find . \( -name \"*.pyc\" -or -name \"__pycache__\" \) -delete"
alias gds="git diff --staged"
alias tmux="tmux -2"
alias weather="curl wttr.in"
alias artisan="php artisan"

# Env file
if [ -f $HOME/.env ]; then
    source $HOME/.env
fi

export PATH="/usr/local/sbin:$PATH"

if [ -d "$HOME/Dropbox/Scripts" ]; then
    export PATH="$HOME/Dropbox/Scripts:$PATH"
fi

if [ -d "$HOME/.composer/vendor/bin" ]; then
    export PATH="$HOME/.composer/vendor/bin:$PATH"
fi

if [ -d "$GOPATH" ]; then
    export PATH="$GOPATH/bin:$PATH"
fi
