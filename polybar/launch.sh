#!/bin/sh

pids=''
onexit() {
    [ -n "$pids" ] && kill $pids
}

killall -q polybar
# wait until polybar finishs execution
while pidof -s polybar >/dev/null; do
	sleep 1
done

for monitor in $(xrandr | grep ' connected ' | cut -d' ' -f 1); do
    env "MONITOR=$monitor" polybar bottom &
    pids="$pids $!"
done

trap onexit INT TERM EXIT

wait $pids
