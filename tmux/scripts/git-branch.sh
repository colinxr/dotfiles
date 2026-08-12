#!/bin/sh
# Current git branch for the tmux status line.
# Prints the branch name (or empty) for the directory passed in $1, so the
# behavior stays in-sync with catppuccin's "gitmux" module without needing the
# external gitmux binary.
#
# Usage: git-branch.sh "<pane_current_path>"

[ -d "${1:-}" ] || exit 0

branch=$(git -C "$1" branch --show-current 2>/dev/null)

if [ -z "$branch" ]; then
  # Detached HEAD — show short SHA instead.
  branch=$(git -C "$1" rev-parse --short HEAD 2>/dev/null)
  [ -n "$branch" ] && branch="($branch)"
fi

[ -n "$branch" ] && printf ' %s' "$branch"