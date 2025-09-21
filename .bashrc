#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

export MONITOR_MODE="2"
export MANPAGER="nvim +Man!"
export PROMPT_COMMAND="history -a"
alias man='man-better'

eval "$(zoxide init bash)"

# History
HISTSIZE=5000
HISTFILESIZE=10000

# Enable vim keybinds for BASH
set -o vi

# Quickly zoxide expand
alias ze='zoxide query'

# Custom evince
alias evince='evincemod'

# BAT configuration
alias cat='bat -pp'

# Making history syncing between terminals automatic
alias hist='history -c && history -r && history | bat --language=sh -pp'

# Clone current terminal quickly
alias clone='kitty --detach .'

# Common folders
export DOCS='/home/buster/Documents'
export CAVI='/home/buster/Documents/CAVI'
export PIXELART='/home/buster/Documents/PixelArt'
export DOT='/home/buster/dotfiles'
export DWLD='/home/buster/Downloads'
export IMGS='/home/buster/Images'
export HYPR='/home/buster/dotfiles/hyprland'
export NVIM='/home/buster/dotfiles/vim/init.lua'
export NOTES='/home/buster/Notes'
export WAYBAR='/home/buster/.config/waybar'
export CONFIG='/home/buster/.config'

# add to PATH:
export PATH="/home/buster/.cargo/bin:$PATH"
export SVN_EDITOR="nvim"
