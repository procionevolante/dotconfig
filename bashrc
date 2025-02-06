#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

_print_err_code() {
    local e=$?
    if [ $e -ne 0 ]; then
        echo -ne "\e[31m$e\e[0m "
    fi
}
# all color escape seq: https://stackoverflow.com/questions/4842424
# (also in console_codes(4) manpage)
PS1='\[\e[32m\]\u@\h \[\e[0m\]\A \[\e[33m\]\w\[\e[0m\]\n\$ '
# prepend error code to prompt if $? != 0
PROMPT_COMMAND='_print_err_code'

cmus() {
	/bin/cmus "$@"
	killall cmusfm
}

# add my scripts to PATH
if [[ "$PATH" != *$HOME/bin* ]]; then
    export PATH="$PATH:$HOME/bin"
fi
# fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# some decent default options for the less pager
export LESS='iFR'
# shell history configuration
export HISTCONTROL=ignorespace
export HISTSIZE=10000

# prevents unattended shutdowns
alias poweroff='read -p "POWEROFF. You sure [y/n]? " -n 1 a; [ "$a" = y ] && poweroff'
# use neovim in place of vim
alias vim='nvim'
alias vimdiff='nvim -d'
# prevents to open view from core/vi which sucks
alias view='nvim -R'
