##
## skunkos .zshrc <rotter.martinos(at)gmail.com>
##

# Set echo-cancellation on pulseaudio.
pactl load-module module-echo-cancel

# Turn off screen blanking.
xset s 0 0
xset -dpms

# Exports.
export EDITOR="/usr/bin/nano"
export GREP_COLOR="1;33"
export LESS="-R"
export LS_COLORS="rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:";
export WORDCHARS='*?_[]~=&;!#$%^(){}'

PATH=$PATH:/opt/alkinea:/opt/sublime_text_3

# Shortcuts.
bindkey ';5D' emacs-backward-word
bindkey ';5C' emacs-forward-word
bindkey '^[[3~' delete-char
bindkey '^[3;5~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# History.
HISTFILE=${HOME}/.martin/zsh/.zsh_history

## The maximum number of events stored in the internal history list.
HISTSIZE=2000

## The maximum number of history events to save in the history file.
SAVEHIST=2000

# Aliases.
alias weather='curl http://wttr.in/Olomouc'
alias top='top -o %MEM'
alias more='less'
alias df='df -h'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias ls='ls --color=auto --human-readable --group-directories-first --classify -A'
alias valgrind-profiler='valgrind --tool=callgrind'
alias ssh-start='eval $(ssh-agent) && ssh-add'
alias virtualbox-run='sudo modprobe vboxdrv vboxnetadp vboxnetflt vboxpci'
alias screenshot='echo "Waiting 2 seconds..." && sleep 2 && import -window root ./screenshot.png'

# Pacman aliases.
alias pac-upg='sudo pacman -Syu'       # Synchronize with repositories before upgrading
alias pac-upd='sudo pacman -Syy'       # Install specific package(s) from the repositories
alias pac-ins='sudo pacman -S'         # Sync specific package
alias pac-upp='sudo pacman -U'         # Upgrade package from file
alias pac-rem='sudo pacman -R'         # Remove the specified package
alias pac-del='sudo pacman -Rns'       # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pac-inr='pacman -Si'             # Display information about a given package in the repositories
alias pac-sea='pacman -Ss'             # Search for package(s) in the repositories
alias pac-inl='pacman -Qi'             # Display information about a given package in the local database
alias pac-num="sudo pacman -Q|wc -l"   # Prints number of installed packages
alias pac-lst='sudo pacman -Q'         # Lists all installed packages
alias pac-lst-size="expac -H M '%m\t%n' | sort -h"			# List all packages with size
alias pac-clr='sudo pacman -Scc'       # Clears entire cache
alias pac-orp='sudo pacman -Qtdq'      # Lists orphaned packages
alias pac-which='pacman -Qo'		       # Checks which package holds file

# Aura aliases.
alias aur-ins='sudo aura -Ax --hotedit'
alias aur-upg='sudo aura -Akxyu --hotedit'

# Autoloads.
autoload -U compinit promptinit colors
compinit -d ${HOME}/.martin/zsh/.completion_dump
promptinit
colors

# Enable expansion in prompt.
setopt prompt_subst
setopt autocd

# Set prompt theme.
source ${HOME}/.martin/zsh/.prompt
setprompt

# Allow "menu" arrows navigation when completing (3 x TAB).
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion::complete:*' cache-path ${HOME}/.martin/zsh/cache
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Complete aliases.
setopt completealiases

# Disable duplicate history entries.
setopt HIST_IGNORE_DUPS

# No beeping.
setopt NO_beep

# Dirstack.
DIRSTACKFILE="$HOME/.martin/zsh/.dirstack"
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
  dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
  [[ -d $dirstack[1] ]] && cd $dirstack[1]
fi
chpwd() {
  print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

DIRSTACKSIZE=20

setopt autopushd pushdsilent pushdtohome

# Remove duplicate entries
setopt pushdignoredups

# This reverts the +/- operators.
setopt pushdminus

# Now you can use dirs -v to print the dirstack.
# Use cd -<NUM> to go back to a visited folder.
# You can use autocompletion after the dash.
# This proves very handy if you are using the autocompletion menu.

# Load misc scripts.
source "$HOME/.martin/zsh/scripts/screenshots.sh"

# Prints out files not owned by any package.
pac-unowned() {
	#!/bin/zsh

	tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
	db=$tmp/db
	fs=$tmp/fs

	mkdir "$tmp"
	trap 'rm -rf "$tmp"' EXIT

	pacman -Qlq | sort -u > "$db"
	find /etc /opt /usr ! -name lost+found \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"
	comm -23 "$fs" "$db"
}
