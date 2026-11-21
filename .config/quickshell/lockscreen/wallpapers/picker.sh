#!/bin/sh
dir=$(dirname "$(realpath "$0")")
wp=$(find "$dir" -maxdepth 1 -type f \( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' \) | shuf -n 1)
case ${wp##*/} in
    berserk.png) theme="#CE0112|#C73636|-75" ;;
    *)           theme="#4B0082|#7675C4|-75" ;;
esac
echo "$wp|$theme"
