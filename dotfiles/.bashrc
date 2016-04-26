alias ls="ls --color=auto"
alias l="ls -a"
alias ll="ls -lh"
alias la="ls -lha"
alias sl="ls"

alias ..="cd .."
alias cd..="cd .."
alias grep="grep --color=auto"

alias v="vim"
alias vi="vim"
alias gdb="gdb -q"

alias gst="git status"
alias ga="git add"
alias gc="git commit"
alias glog="git log --oneline --decorate"
alias gd="git diff"
alias gds="git diff --staged"
alias gp="git push"

alias seedbox='transmission-remote localhost:9091'
alias tmux='tmux -2'

export EDITOR=vim

export PROMPT_COMMAND=__display_prompt
function __display_prompt() {
    local EXIT="$?"
    PS1="\[\e[0;32m\][\u@\h] \[\e[0;33m\]\W"

    if [ $EXIT -eq 0 ]; then
        PS1+="\[\e[m\] $ "
    else
        PS1+="\[\e[0;31m\] (${EXIT}) $ \[\e[m\]"
    fi
}
