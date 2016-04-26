# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="dethi"

plugins=(git extract jump docker docker-compose sudo)
if [ $(uname) = "Darwin" ]; then
    plugins+=(osx brew)
fi

source $ZSH/oh-my-zsh.sh

export EDITOR="vim"
export NNTPSERVER="news.epita.fr"

export PATH="/usr/local/sbin:$PATH"

if [ -d "$HOME/Dropbox/Scripts" ]; then
    export PATH="$HOME/Dropbox/Scripts:$PATH"
fi

if [ -d "$HOME/Documents/gocode" ]; then
    export GOPATH="$HOME/Documents/gocode"
    export PATH="$GOPATH/bin:$PATH"
fi

# Alias
alias avenv="source ./env/bin/activate"
alias rmpyc="find . \( -name \"*.pyc\" -or -name \"__pycache__\" \) -delete"
alias gds="git diff --staged"

alias rsync="rsync -avz --exclude='*.o' --exclude='*.so' --exclude='.git'"
alias tmux="tmux -2"
alias lynx="lynx -useragent='Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101 Firefox/38.0 Iceweasel/38.6.0'"
alias weather="curl wttr.in"

alias epigcc="gcc -std=c99 -pedantic -Wall -Wextra -g"
alias epig++="g++ -std=c++14 -pedantic -Wall -Wextra -g"

# Env file
if [ -f $HOME/.env ]; then
    source $HOME/.env
fi
