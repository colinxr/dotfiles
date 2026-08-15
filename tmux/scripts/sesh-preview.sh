#!/bin/sh
# Preview pane for sesh-picker.sh — shows windows of a live tmux session,
# or branch + contents for a directory (zoxide) entry.

case "$1" in
  '~'*) target="$HOME${1#\~}" ;;
  *) target="$1" ;;
esac

if tmux has-session -t "$1" 2>/dev/null; then
  tmux list-windows -t "$1" -F '#{?window_active,●,○} #{window_index}: #{window_name}'
  exit 0
fi

if [ -d "$target" ]; then
  branch=$(git -C "$target" branch --show-current 2>/dev/null)
  [ -n "$branch" ] && echo "git: $branch"
  ls -p "$target"
else
  echo "$1"
fi
