#!/usr/bin/env bash
python3 -m wyoming_piper \
    --piper '/usr/share/piper/piper' \
    --cuda \
    --uri 'tcp://0.0.0.0:10200' \
    --data-dir /data \
    --download-dir /data "$@"
