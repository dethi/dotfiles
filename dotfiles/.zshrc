ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"

plugins=(osx git extract jump docker golang sudo)

source $ZSH/oh-my-zsh.sh

export EDITOR="vim"
export GOPATH="$HOME/go"

# Alias
alias reload="source $HOME/.zshrc"
alias avenv="source ./.venv/bin/activate"
alias rmpyc="find . \( -name \"*.pyc\" -or -name \"__pycache__\" \) -delete"
alias gd="git diff"
alias gds="git diff --staged"
alias tmux="tmux -2"
alias weather="curl wttr.in"
alias json="python -m json.tool"
alias rmbranch="git branch --merged master | grep -v \"\* master\" | xargs -n 1 git branch -d"

# Env file
if [ -f $HOME/.env ]; then
    source $HOME/.env
fi

export PATH="/usr/local/sbin:$PATH"

if [ -d "$HOME/Dropbox/Scripts" ]; then
    export PATH="$HOME/Dropbox/Scripts:$PATH"
fi

if [ -d "$GOPATH" ]; then
    export PATH="$GOPATH/bin:$PATH"

    # setopt auto_cd
    # cdpath=($GOPATH/src/github.com)
fi

function lb() {
    mkdir -p ~/logbook
    $EDITOR ~/logbook/$(date '+%Y-%m-%d').md
}

# Enable IEx history
export ERL_AFLAGS="-kernel shell_history enabled"

# Create virtualenv localy
export PIPENV_VENV_IN_PROJECT=1
