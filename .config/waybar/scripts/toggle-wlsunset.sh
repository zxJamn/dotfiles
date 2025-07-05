#!/bin/bash

PID=$(pidof wlsunset)

if [ -n "$PID" ]; then
    kill "$PID"
    notify-send "󰹐 Night mode OFF"
else
    setsid wlsunset -l 51.5 -L -0.12 -t 3500 -T 6500 >/dev/null 2>&1 &
    notify-send "󰖔 Night mode ON"
fi

pkill -SIGRTMIN+9 waybar
