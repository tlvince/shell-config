# profile: sourced by the login shell.

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
            if [[ -n $SSH_TTY ]]; then
                tmux has && tmux attach || tmux new
            fi
    esac
fi
