# profile: sourced by the login shell.
# Copyright 2009-11 Tom Vincent <http://www.tlvince.com/contact/>

. "$XDG_CONFIG_HOME/shell/zsh/.zshrc"

# Start {ssh,gpg}-agent
eval $(keychain --eval --quiet)

# Restore volume levels
[[ -f ~/.config/alsa/state ]] && {
    alsactl -f ~/.config/alsa/state restore
}

# Launch X or tmux depending on the tty
if [[ -z "$DISPLAY" ]]; then
    case $(tty) in
        /dev/tty1)
            # Fix login security hole (^c)
            startx &!
            logout
        ;;
        /dev/tty2)
            tmux
            logout
        ;;
        *)
            # If we're SSH'ed, attach to a running tmux session or start a fresh
            if [[ -n $SSH_TTY ]]; then
                if [[ -z $TMUX ]]; then
                    tmux has && tmux attach || tmux new
                    logout
                fi
            fi
    esac
fi
