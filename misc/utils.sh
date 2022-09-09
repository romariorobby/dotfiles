#!/bin/sh
LOG_FILE="$HOME/.cache/chezmoi/install.log"
err () { printf "\33[2K\r\033[1;31m%s\033[0m\n" "$*" >&2; }
suc () { printf "\33[2K\r\033[1;32m%s\033[0m\n" "$*"; }
die () { err "$*"; exit 1; }

bold="$(tput bold)"
normal="$(tput sgr0)"

red='\e[1;31m'
green='\e[1;32m'
yellow='\e[1;33m'
blue='\e[1;34m'
magenta='\e[1;35m'
cyan='\e[1;36m'

_spinner() {
    pid="$!"
    chars="⣾ ⣽ ⣻ ⢿ ⡿ ⣟ ⣯ ⣷"
    # chars='/-\|'
    while kill -0 "$pid" 2>/dev/null; do
        printf "${blue}%s${normal}" "$* " 1>&2
        BCK=''
        for char in $chars ; do
            printf "\b%s" "$BCK$char" 1>&2
            sleep 0.1
        done
        printf "\033[2K\r" 1>&2
    done
}

# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring,
# otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if test "${string#*$substring}" != "$string"; then
        return 0    # $substring is in $string
    else
        return 1    # $substring is not in $string
    fi
}

log(){
    [ "$CM_LOG" = false ] && return 1
    if [ -n "$1" ]; then
        message="$1"
        echo "[$(date '+%H:%M:%S')]: ${message}" >>"${LOG_FILE}"
    else
        # Command output
        echo "*** COMMAND OUTPUT ***" >>"${LOG_FILE}"
        while read -r message; do
            echo "${message}" >>"${LOG_FILE}"
        done
        echo "*** END OF COMMAND OUTPUT ***" >>"${LOG_FILE}"
    fi
}

read_pass(){
  stty -echo
  trap 'stty echo' EXIT
  read "$@"
  stty echo
  trap - EXIT
  printf "\n"
}

inputpass(){
  printf "Enter Password for [$1]: "; read_pass pass1
  printf "Retype Password for [$1]: "; read_pass pass2
  while ! [ "$pass1" = "$pass2" ]; do
    unset pass2
    err "Password do not match"
    printf "Enter password again for [$1]: "; read_pass pass1
    printf "Retype Password again for [$1]: "; read_pass pass2
  done
}
