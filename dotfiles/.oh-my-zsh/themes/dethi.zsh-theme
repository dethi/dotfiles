local return_status="%(?:%{$fg_bold[green]%}➜:%{$fg_bold[red]%}➜)"
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✖%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

PROMPT='${return_status} %{$fg[green]%}[%n] %{$fg[yellow]%}%c %{$fg[blue]%}$(git_prompt_info)%{$reset_color%} %s'
RPROMPT='${return_code}'
