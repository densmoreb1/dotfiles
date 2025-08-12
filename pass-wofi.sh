#!/bin/sh
entry=$(find ~/.password-store -name '*.gpg' | sed 's#^.*/##' | sed 's/\.gpg$//' | wofi --dmenu -i -p "Pass")
[ -n "$entry" ] && pass show -c "$entry"
