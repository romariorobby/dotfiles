#!/bin/sh
progsfile="$1"

case "$2" in
  "server"|"headless") abb="SH";;
  "base") abb="B";;
  "minimal") abb="M";;
  "full") abb="F" ;;
  "help") printf "server/headless\\nbase\\nminimal\\nfull\\n" ;;
  *) echo "No Filter set"; exit 1 ;;
esac
[ "$3" = "all" ] && { grep "^\w\+\?[$abb]" "$progsfile" && exit 1; }

grep -v "^\w\+\?[X]\|,\w\+\?[X]" "$progsfile" | grep "^\w\+\?[$abb]"

