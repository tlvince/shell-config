# profile: sourced by the login shell.

alsactl -f ~/.config/alsa/state restore

if [[ -z "$DISPLAY" ]]; then
    case $(tty) in
        /dev/tty1)
            # Fix login security hole (^c)
            startx &
            logout
        ;;
        /dev/tty2)
            tmux
            logout
        ;;
    esac
fi
