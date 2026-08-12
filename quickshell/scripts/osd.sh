#!/usr/bin/env bash
# Writes the current volume / brightness level to a state file that the
# quickshell OSD (Osd.qml) watches via FileView. Call this *after* the
# wpctl / brightnessctl command that changed the value.
#
#   osd.sh volume       -> read default sink, write volume state
#   osd.sh brightness   -> read backlight, write brightness state
#   osd.sh init         -> write a hidden placeholder (ts=0) so the file
#                          exists at login and the OSD doesn't pop on start
set -euo pipefail

state_file="${XDG_RUNTIME_DIR:-/tmp}/quickshell-osd.json"
kind="${1:-}"

# A monotonically-increasing nonce so the file content always changes even
# when the value is identical (e.g. volume already at 100% and raised again),
# which is what makes FileView re-fire and re-show the OSD.
ts=$(date +%s%N)

case "$kind" in
  volume)
    out=$(wpctl get-volume @DEFAULT_SINK@)          # "Volume: 0.72 [MUTED]"
    vol=$(awk '{print $2}' <<<"$out")
    muted=false
    [[ "$out" == *"[MUTED]"* ]] && muted=true
    pct=$(awk "BEGIN{printf \"%d\", $vol*100 + 0.5}")
    ;;
  brightness)
    cur=$(brightnessctl get)
    max=$(brightnessctl max)
    pct=$(awk "BEGIN{printf \"%d\", $cur/$max*100 + 0.5}")
    muted=false
    ;;
  init)
    printf '{"kind":"volume","value":0,"muted":false,"ts":0}\n' > "$state_file"
    exit 0
    ;;
  *)
    echo "usage: osd.sh {volume|brightness|init}" >&2
    exit 1
    ;;
esac

printf '{"kind":"%s","value":%d,"muted":%s,"ts":%s}\n' "$kind" "$pct" "$muted" "$ts" > "$state_file"
