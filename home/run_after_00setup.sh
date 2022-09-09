#/bin/sh
# I'm not sure why we need to do there, even though i have cleanup all .bashrc related in $HOME
grep -q ".config}/bash/.bashrc" /etc/bash.bashrc > /dev/null || printf '
if [ -s "${XDG_CONFIG_HOME:-$HOME/.config}/bash/.bashrc" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/bash/.bashrc"
fi' | sudo tee -a /etc/bash.bashrc
