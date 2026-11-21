# shellcheck shell=bash
# What the scripts in ~/.local/bin have in common. A script uses it like this, near the top:
#   APP=books   (its name in notifications, and its window's app id)
#   # shellcheck source-path=SCRIPTDIR source=../lib/common.sh
#   . "$HOME/.local/lib/common.sh"
# Anything the script defines after that wins, so it can keep its own version of any of these.

APP=${APP:-${0##*/}}

# fzf in the wallpaper's colours: only the terminal's 16 colours, which kitty takes from pywal, never fzf's own fixed
# ones. Everything stays on the background (kitty's, see-through), which `wallpaper warm` makes every colour readable
# on; the current line is bright and bold with an accent pointer, not a coloured bar (dimmed parts, like kp's
# usernames, turned unreadable on one)
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS:+$FZF_DEFAULT_OPTS }--color=16,fg:7,bg:-1,hl:4,fg+:15:bold,bg+:-1,hl+:4:bold:underline,gutter:-1,pointer:4,marker:6,spinner:6,info:8,prompt:4,query:7,header:6,border:8,separator:8,scrollbar:8,label:7,preview-fg:7,preview-bg:-1"

notify() { notify-send --app-name="$APP" "$@" >/dev/null 2>&1 || true; }
die() { printf '%s\n' "$*" >&2; notify --urgency=critical "${APP^}" "$*"; exit 1; }
need() {
    local p
    for p; do command -v "$p" >/dev/null || die "$p isn't installed (sudo pacman -S $p)"; done
}
short() { echo "${1/#$HOME/\~}"; }

# for scripts that print what they're doing in a terminal (update, sys-setup, cleaner)
step() { printf '\n\e[1m== %s\e[0m\n' "$1"; }
warn() { printf '\e[1;33m%s\e[0m\n' "$1"; }
say() { printf '  %s\n' "$*"; }
# shellcheck disable=SC2034  # failed is for the script, to say at the end that something didn't finish
bad() { printf '\e[1;33m  %s\e[0m\n' "$*"; failed=1; }

# this script becomes kitty running COMMAND (in your pywal colours):  term_exec [KITTY OPTION…] -e COMMAND…
term_exec() {
    command -v kitty >/dev/null || die "kitty isn't installed (sudo pacman -S kitty)"
    exec kitty "$@"
}
# this script again, in its own window (app id and title: $APP; more kitty options in WINDOW_OPTS)
window() { term_exec --app-id="$APP" --title="$APP" "${WINDOW_OPTS[@]}" -e "${SELF:-$0}" "$@"; }

# sends a command to the mpv at $SOCK and prints its answer; fails if it isn't running
ipc() {
    [ -S "$SOCK" ] || return 1
    python3 -I - "$SOCK" "$@" <<'EOF'
import json, socket, sys
s = socket.socket(socket.AF_UNIX)
s.settimeout(3)
try:
    s.connect(sys.argv[1])
    s.sendall((json.dumps({"command": sys.argv[2:]}) + "\n").encode())
    buf = b""
    while True:
        c = s.recv(65536)
        if not c:
            sys.exit(1)
        buf += c
        while b"\n" in buf:
            line, buf = buf.split(b"\n", 1)
            r = json.loads(line)
            if "event" not in r:
                if r.get("data") is not None:
                    print(r["data"] if isinstance(r["data"], str) else json.dumps(r["data"]))
                sys.exit(0 if r.get("error") == "success" else 1)
except (OSError, ValueError):
    sys.exit(1)
EOF
}

alive() { ipc get_property pid >/dev/null 2>&1; }

FZCOLORS='fg:-1,bg:-1,hl:4,fg+:-1:bold,bg+:-1,hl+:4:bold,gutter:-1,pointer:5,marker:4,prompt:4,query:-1:bold,info:8,header:8,spinner:4,separator:8,scrollbar:8'

# the fzf here knows this option (older ones don't)
fzf_has() { fzf --filter x "$@" </dev/null >/dev/null 2>&1; [ $? != 2 ]; }

# the lists' look (FZS), the search box (PROMPT, with $1 as its hint), and what this fzf can do:
# NI hides the preview's line count, TABLE is set when it can draw the list with borders and columns
# shellcheck disable=SC2034  # these are for the script
fzstyle() {
    FZS=(--ansi --layout=reverse --info=hidden --no-scrollbar --no-separator --ellipsis='…'
        --pointer='▌' --marker='▌' --color="$FZCOLORS" --bind 'ctrl-bspace:backward-kill-word')
    fzf_has --gutter=' ' && FZS+=(--gutter=' ')
    PROMPT=(--prompt='› ')
    [ -n "${1:-}" ] && fzf_has --ghost=x && PROMPT=(--prompt='  ' --ghost="$1")
    NI=''
    fzf_has --preview-window=noinfo && NI=',noinfo'
    TABLE=''
    fzf_has --list-border && fzf_has --highlight-line && TABLE=1
}

# TIMES[name]=value for each "name value" line in times.conf (or in $1); a name given twice takes the last
# shellcheck disable=SC2034  # TIMES is for the script
times_load() {
    declare -gA TIMES=()
    local f=${1:-${XDG_CONFIG_HOME:-$HOME/.config}/times.conf} k v
    [ -f "$f" ] || return 0
    while read -r k v || [ -n "$k" ]; do [ -n "$k" ] && TIMES[$k]=$v; done < "$f"
    return 0
}

# asks for your password once, then keeps sudo unlocked until the script ends
sudo_keep() {
    sudo -v || return 1
    ( while kill -0 $$ 2>/dev/null; do sudo -n -v 2>/dev/null; sleep 50; done ) & SUDO_KEEP=$!
    trap 'kill $SUDO_KEEP 2>/dev/null' EXIT
}

# pacman, yay or an app store is installing something in another window (or holds pacman's lock)
pacman_busy() {
    pgrep -x 'pacman|yay|paru|makepkg|pamac' >/dev/null && return 0
    [ -e /var/lib/pacman/db.lck ] && sudo fuser /var/lib/pacman/db.lck >/dev/null 2>&1
}

# a lock left behind by a pacman that crashed or lost power stops every install; it's only
# removed when nothing has it open (fuser, from psmisc, checks)
unlock_pacman() {
    [ -e /var/lib/pacman/db.lck ] || return 0
    command -v fuser >/dev/null || { printf "pacman's lock (/var/lib/pacman/db.lck) is there, and fuser isn't installed to check nothing's using it, so it's left.\n"; return 1; }
    pacman_busy && return 0
    sudo rm -f /var/lib/pacman/db.lck
}
