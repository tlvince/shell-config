# profile: sourced by the login shell.
# Copyright 2009-11 Tom Vincent <http://www.tlvince.com/contact/>

XDG=(.local/share .config .cache)
for i in $XDG; do
    [[ ! -d "$HOME/$i" ]] && mkdir -p "$HOME/$i"
done

. "$XDG_CONFIG_HOME/shell/zsh/.zshrc"

[[ -f ~/.config/alsa/state ]] && {
    alsactl -f ~/.config/alsa/state restore
}

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
