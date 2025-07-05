#!/bin/bash

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"
POWERSAVE_CONF="/home/jam/.config/hypr/decorations-powersave.conf"
GAMING_CONF="/home/jam/.config/hypr/decorations-gaming.conf"

CURRENT_SOURCE=$(grep -E "^[[:space:]]*source[[:space:]]*=[[:space:]]*\/home\/jam\/\.config\/hypr\/decorations-(powersave|gaming)\.conf" "$HYPR_CONFIG" | head -n 1 | awk '{print $NF}' | tr -d '[:space:]')

NEW_SOURCE=""
NOTIFICATION_MESSAGE=""

if [[ "$CURRENT_SOURCE" == "$POWERSAVE_CONF" ]]; then
    NEW_SOURCE="$GAMING_CONF"
    NOTIFICATION_MESSAGE="Switched to Gaming Mode  "
elif [[ "$CURRENT_SOURCE" == "$GAMING_CONF" ]]; then
    NEW_SOURCE="$POWERSAVE_CONF"
    NOTIFICATION_MESSAGE="Switched to Power Save Mode "
else
    echo "Warning: Could not detect current decoration profile. Defaulting to Gaming Mode (initial setup)." >&2
    NEW_SOURCE="$GAMING_CONF"
    NOTIFICATION_MESSAGE="Initial setup: Set to Gaming Mode  "
fi

if [[ -n "$NEW_SOURCE" ]]; then
    sed -i -E "s|^(.*source[[:space:]]*=[[:space:]]*).*$|\1$NEW_SOURCE|" "$HYPR_CONFIG"

    hyprctl reload

    notify-send "Hyprland Profile" "$NOTIFICATION_MESSAGE"
else
    notify-send "Hyprland Profile Error" "Failed to determine new profile to switch to."
fi
