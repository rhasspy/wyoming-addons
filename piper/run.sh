#!/usr/bin/env bash
set -e

python3 -m wyoming.http.tts_server \
    --uri 'tcp://127.0.0.1:10200' \
    --host '0.0.0.0' \
    --port 5000 &
HTTP_SERVER_PID=$!

python3 -m wyoming_piper \
    --piper '/usr/share/piper/piper' \
    --uri 'tcp://0.0.0.0:10200' \
    --data-dir /data \
    --download-dir /data "$@" &
MAIN_APP_PID=$!

# Forward termination signals to child processes
terminate() {
    echo "Terminating..."
    kill -TERM "${HTTP_SERVER_PID}" "${MAIN_APP_PID}"
    wait
}

trap terminate SIGTERM SIGINT

wait "${MAIN_APP_PID}"
terminate
