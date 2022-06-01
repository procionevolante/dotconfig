#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='\[\e[32m\]\u@\h \[\e[0m\]\D{%H:%M} \[\e[33m\]\w\[\e[0m\]\n\$ '

cmus() {
	/bin/cmus "$@"
	killall cmusfm
}

# prevents unattended shutdowns
alias poweroff='read -p "POWEROFF. You sure [y/n]? " -n 1 a; [ "$a" = y ] && poweroff'
# use neovim that has fancier cursor and apparently works better
alias vim='nvim'
# prevents to open view from core/vi which sucks
alias view='nvim -R'
