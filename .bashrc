#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

XDG_MENU_PREFIX=arch- kbuildsycoca6

export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/src/PixelView/_build:$PATH"
export PATH="$HOME/.local/share/gem/ruby/3.3.0/bin:$PATH"

eval "$(pyenv init --path)"
eval "$(pyenv init -)"

export ANKI_WAYLAND=1

eval "$(zoxide init bash)"
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"
export XDG_CURRENT_DESKTOP=GNOME

fortune | cowsay

tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

export PATH=$PATH:~/.local/bin
