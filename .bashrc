#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias lss='eza -l --sort=size -r --all --no-permissions --no-user --no-time --icons=always --only-files && eza -l --sort=size -r --all --no-permissions --no-user --no-time --icons=always --only-dirs --total-size'
alias l='eza -l --sort=size -r --all --no-permissions --no-user --no-time --icons=always --only-dirs && eza -l --sort=size -r --all --no-permissions --no-user --no-time --icons=always --only-files'
alias grep='grep --color=auto'
function rm() {
	rip "$@"
	l
}
function mv() {
	/usr/bin/mv "$@"
	l
}
function cp() {
	/usr/bin/cp "$@"
	l
}
# Function for moving large files
function cpl() {
	rsync -ah --progress "$@"
}

# This is the prompt before every command!
PS1='> '

export MONITOR_MODE="2"
export MANPAGER="nvim +Man!"
export PROMPT_COMMAND="history -a"
alias man='man-better'

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

# yazi:
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
#
cd() {
    builtin cd "$@" || return
    l
}
z() {
	# We first of all check if the user has actually written any arguments, or just wants to use `z` directly to go to home dir
	if [ -z "$@" ]
	then
		builtin cd
	else
		# We then check if a succesful match exists. We make sure to redirect both the normal query result and the potential error result into stderr to not print anything unneccesary:
		if /usr/bin/zoxide query "$@" > /dev/null 2>&1
		then
			# Finally, we use `cd` (which is a bash thing, not a program per say ... ), to get to the expanded query
			builtin cd `/usr/bin/zoxide query "$@"`
		else
			# If one does not exist, but can be found in the folder, we add it
			if [ -d "$@" ] 
			then
				/usr/bin/zoxide add "$@"
				builtin cd "$@"
			fi
		fi
	fi
	l
}
zi() {
	cd `/usr/bin/zoxide query --interactive`
}

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


PATH="/home/buster/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/buster/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/buster/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/buster/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/buster/perl5"; export PERL_MM_OPT;
