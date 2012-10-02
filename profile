# profile: sourced by the login shell. {{{1
# Copyright 2009-11 Tom Vincent <http://tlvince.com/contact/>
# vim: set fdm=marker

# Helper functions. {{{1

# Is $1 installed?
_have() { which "$1" &>/dev/null; }

# Environment
[ $XDG_CONFIG_HOME ] || export XDG_CONFIG_HOME="$HOME/.config"
[ $XDG_CACHE_HOME ]  || export XDG_CACHE_HOME="$HOME/.cache"
[ $XDG_DATA_HOME ]   || export XDG_DATA_HOME="$HOME/.local/share"

# Main. {{{1
. "$XDG_CONFIG_HOME/shell/zsh/.zshrc"

# Start {ssh,gpg}-agent
_have keychain && eval $(keychain --eval --quiet)

# Launch X or tmux depending on the tty
if [[ -z "$DISPLAY" ]]; then
    case $(tty) in
        /dev/tty1)
            # Fix login security hole (^c)
            xinit "$XDG_CONFIG_HOME/xorg/xinitrc" -- /usr/bin/X -nolisten tcp &!
            logout
        ;;
        /dev/tty2)
            tmux
            logout
        ;;
        *)
            if [[ -n $SSH_TTY ]]; then
                # Not all systems have rxvt-unicode
                TERM=xterm-color

                # If we're SSH'ed, attach to a running tmux session or start a fresh
                if _have tmux; then 
                    if [[ -z $TMUX ]]; then
                        tmux has 2>/dev/null && tmux attach || tmux new
                        logout
                    fi
                fi
            fi
    esac
fi
