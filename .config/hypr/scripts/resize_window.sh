#!/bin/bash

# Get active window ID
WINDOW_ID=$(hyprctl activewindow -j | jq -r '.address')

# Get current window geometry
GEOMETRY=$(hyprctl activewindow -j | jq -r '.size | "\(.x) \(.y)"')
read -r WIDTH HEIGHT <<< "$GEOMETRY"

# Get requested changes
CHANGE_X=${1:-0}
CHANGE_Y=${2:-0}

NEW_WIDTH=$((WIDTH + CHANGE_X))
NEW_HEIGHT=$((HEIGHT + CHANGE_Y))

# Apply resize
hyprctl dispatch resizewindow $NEW_WIDTH $NEW_HEIGHT,$WINDOW_ID
