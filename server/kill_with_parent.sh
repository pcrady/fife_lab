#!/bin/sh
"$1" "${@:2}" &
child=$!
# Block until our stdin closes (parent gone)
cat >/dev/null
kill -TERM "$child"
wait "$child"
