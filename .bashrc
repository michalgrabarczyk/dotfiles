# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


###########################################
# COLOURS AND OTHER PROMPT DEFINITIONS
###########################################

COLOR_RESET='\[\033[0m\]'
RED='\[\033[1;31m\]'
GREEN='\[\033[1;32m\]'
YELLOW='\[\033[1;33m\]'
PURPLE='\[\033[1;35m\]'
WHITE='\[\033[1;37m\]'
BLUE='\[\033[1;34m\]'
CYAN='\[\033[1;36m\]'

CLOCK="\A"
PS1_USERNAME="\u"
PS1_CMD_PROMPT=" >"
PS1_PWD="\w"
PS1_HOSTNAME="\h"


#####################
# EXPORTS
#####################

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth:erasedups
# append to the history file, don't overwrite it
shopt -s histappend

# expand the history size
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/
export PATH=$PATH:$JAVA_HOME

# Cuda
export LD_LIBRARY_PATH=/usr/local/cuda/lib64/:$LD_LIBRARY_PATH
export PATH=/usr/local/cuda/bin/:$PATH

# command line prompt
PS1="${CYAN}${PS1_USERNAME} ${PURPLE}${PS1_HOSTNAME}${WHITE} ${BLUE}${PS1_PWD}${GREEN}\`parse_git_branch\`${WHITE}${PS1_CMD_PROMPT} ${COLOR_RESET}"

# Unibas related

# Compiled clang-7
export LD_LIBRARY_PATH=/home/grabar0000/tools/llvm/llvm-7.0.0.src/install/lib:$LD_LIBRARY_PATH
export PATH=~/tools/llvm/llvm-7.0.0.src/install/bin:$PATH


###########################################
# ALIASES
###########################################

alias ga='git add'
alias gst='git status'
alias gd='git diff'
alias gci='git commit -m'
alias grmb='function remove_branch(){ git push origin --delete $1; git branch -d $1; }; remove_branch'

# ls aliases
alias ls='ls -aFh --color=always'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# grep aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ag="ag --color-path '1;34' --color-match '1;32' --color-line-number 32"

# cd
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias cdfinice='cd ~/AndroidStudioProjects/hajsy/'
alias cdcpp='cd ~/cpp'
alias cdsph='cd ~/unibas/sph-exa_mini-app/'

# android
alias fixadb='pushd ~/Android/Sdk/platform-tools/; ./adb kill-server; sleep 3; sudo ./adb devices; popd'

#other
alias em='emacs -q -nw'

#misc

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Search files in the current folder
alias f="find . | ag "


###########################################
# FUNCTIONS
###########################################

# git PS1 indicators helper functions

# get current status of git repo
parse_git_dirty () {
    status=`git status 2>&1 | tee`
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
	bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
	bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
	bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
	bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
	bits="x${bits}"
    fi
    if [ "${dirty}" == "0" ]; then
	bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
	echo " ${bits}"
    else
	echo ""
    fi
}

# get current branch in git repo
parse_git_branch () {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo " [${BRANCH}${STAT}] "
    else
        echo ""
    fi
}


###########################################
# SOURCE OTHER FILES
###########################################

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
