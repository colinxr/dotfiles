#!/bin/sh
# Expressive pane path for the tmux status line.
# Outputs the pane's working directory with $HOME collapsed to ~ and trimmed
# to the last two path components (parent/basename) so nested project paths
# stay readable in the status bar.
#
# Usage: pane-context.sh "<pane_current_path>"

pwd="${1:-$PWD}"

case "$pwd" in
  "$HOME") printf '~' && exit 0 ;;
  "$HOME"/*) pwd="~${pwd#"$HOME"}" ;;
esac

# Trim to last two components.
echo "$pwd" | awk -F/ '{
  n = NF
  if (n <= 2) { print; exit }
  if ($1 == "~") print "~/" $(n-1) "/" $n
  else         print $(n-1) "/" $n
}'