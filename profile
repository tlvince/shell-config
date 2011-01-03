# profile: sourced by the login shell.

[[ -f ~/.config/alsa/state ]] && {
    alsactl -f ~/.config/alsa/state restore
}
. "$XDG_CONFIG_HOME/shell/zsh/.zshrc"

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
    esac
fi
