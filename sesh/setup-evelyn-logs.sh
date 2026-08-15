#!/bin/bash
# Setup evelyn logs window with horizontal split
# Left: make logs-api | Right: make logs

# Create horizontal split
tmux split-window -h -p 50

# Send commands to each pane
tmux send-keys -t 0 'make logs-api' C-m
tmux send-keys -t 1 'make logs' C-m
