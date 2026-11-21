# ~/.zprofile: read once when you log in on a tty. Everything MangoWM starts
# (Glide, keybinds, the file picker) inherits these, not just terminals.
typeset -U path PATH
path=("$HOME/.local/bin" $path /usr/lib/qt6/bin)
export PATH
export EDITOR=nvim VISUAL=nvim
# ssh-agent.socket (systemd user unit): the key is unlocked once per login
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket

# Start MangoWM on tty1 after a plain console login. Logging in through ly
# (XDG_SESSION_TYPE=wayland) it isn't needed: ly reads this file, then starts
# the session you picked there. Keep this last: exec replaces the shell, so
# nothing below it would run.
[[ $XDG_SESSION_TYPE == tty && "$(tty)" == "/dev/tty1" ]] && exec mango
