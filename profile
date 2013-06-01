# profile: sourced by the login shell. {{{1
# Copyright 2009-2013 Tom Vincent <http://tlvince.com/contact/>
# vim: set fdm=marker ft=sh

have() { which "$1" &>/dev/null; }

# OS X
[ $(uname) = "Darwin" ] && source \
  "$HOME/Library/Application Support/osx/profile.sh"

# systemd/freedesktop spec
os="/etc/os-release"
[ -f "$os" ] && {
  grep -q "ID=arch" "$os" && source "$HOME/.config/arch/profile.sh"
}

# Default environment
[ $XDG_CONFIG_HOME ] || export XDG_CONFIG_HOME="$HOME/.config"
[ $XDG_CACHE_HOME ]  || export XDG_CACHE_HOME="$HOME/.cache"
[ $XDG_DATA_HOME ]   || export XDG_DATA_HOME="$HOME/.local/share"

# Start tmux
[ -n $SSH_TTY ] && [ -z $TMUX ] && have tmux && {
  tmux has 2>/dev/null && exec tmux attach || exec tmux new
}
