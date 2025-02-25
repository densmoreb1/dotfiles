if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Alias
alias l="ls -lav"
alias gs="git status"
alias t="tree"
alias ip='ip --color=auto'
alias v='nvim'

set -g fish_key_bindings fish_vi_key_bindings
set fish_greeting

starship init fish | source

