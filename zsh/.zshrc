##
## skunkos .zshrc <rotter.martinos(at)gmail.com>
##

# Turn off screen blanking on Linux.
if [[ ("$(uname -o)" != "Cygwin") && (! -n "$SSH_CLIENT") && (! -n "$SSH_TTY") ]]; then
  xset s 0 0
  xset -dpms
fi

if [[ "$(uname -o)" == "Cygwin" ]]; then
  PATH="/cygdrive/c/Program Files (x86)/Microsoft Visual Studio 12.0/VC/bin/":"/cygdrive/c/Qt/5.7/msvc2013/bin/":$PATH
fi

# Tilix fix.
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source "/etc/profile.d/vte.sh"
fi

# Exports.
export EDITOR="/usr/bin/micro"
export GREP_COLOR="1;33"
export LESS="-R"
export LS_COLORS="rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:";
export WORDCHARS='*?_[]~=&;!#$%^(){}'
export SAL_USE_VCLPLUGIN="gtk"        # For LibreOffice gui.

# History.
HISTFILE="${HOME}/.zhistory"

## The maximum number of events stored in the internal history list.
HISTSIZE=2000

## The maximum number of history events to save in the history file.
SAVEHIST=2000

# Aliases.
alias weather='curl http://wttr.in/Olomouc'
alias more='less'
alias df='df -h'
alias grep='grep --colour=auto'
alias ls='ls --color=auto --human-readable --group-directories-first --classify -lhA'
alias valgrind-profiler='valgrind --tool=callgrind'
alias ssh-start='eval $(ssh-agent) && ssh-add'
alias screenshot='echo "Waiting 2 seconds..." && sleep 2 && import -window root ./screenshot.png'
alias mount-encfs='encfs $HOME/Dropbox/martin/ $HOME/.martin/encrypted/'
alias tally='sudo pam_tally2'
alias ssh-ips='journalctl -u sshd | grep "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" -o | sort -u'

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
alias pac-orp='sudo pacman -Qt'        # Lists orphaned packages
alias pac-which='pacman -Qo'		       # Checks which package holds file

# PACAUR aliases.
alias aur-ins='pacaur -S'
alias aur-upg='pacaur -Syu'
alias aur-upg-devel='pacaur -Syua --devel --needed'

# Functions.
play-youtube-dl() {
  youtube-dl $1 -o -| vlc -
}

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

# Load powerless.
source ~/.martin/powerless/powerless.zsh
source ~/.martin/powerless/utilities.zsh