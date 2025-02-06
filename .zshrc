# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export EDITOR="vim"

export HISTSIZE=5000
export SAVEHIST=5000

ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.cache/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"

# Docker Format
export PS_FORMAT="ID\t{{.ID}}\nNAME\t{{.Names}}\nImage\t{{.Image}}\nPORTS\t{{.Ports}}\nCOMMAND\t{{.Command}}\nCREATED\t{{.CreatedAt}}\nSTATUS\t{{.Status}}\n"

# Theme
ZSH_THEME="gallois"

# Plugins
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# ohmyzsh
source $ZSH/oh-my-zsh.sh

# Alias
alias l="ls -lav"
alias gs="git status"
alias t="tree"
alias ip='ip --color=auto'
alias v='nvim'

# Vim on CLI
bindkey -v

