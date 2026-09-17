#!/bin/sh

pgrep -x wofi >/dev/null 2>&1 && killall wofi ; wofi \
	--width=30% \
	--height=50% \
	--hide-scroll \
	--prompt="..." \
	--insensitive \
	-n \
	--show="${1}"


