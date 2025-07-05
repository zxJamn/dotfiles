#!/bin/bash

if pidof wlsunset >/dev/null; then
    ICON="󰖔"
    CLASS="enabled"
else
    ICON="󰖙"
    CLASS="disabled"
fi

echo "{\"text\": \"$ICON\", \"class\": \"$CLASS\"}"#!/bin/bash

if pidof wlsunset >/dev/null; then
    ICON="󰖔"
    CLASS="enabled"
else
    ICON="󰖙"
    CLASS="disabled"
fi

echo "{\"text\": \"$ICON\", \"class\": \"$CLASS\"}"
