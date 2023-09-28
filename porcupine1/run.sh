#!/usr/bin/env bash
python3 /usr/src/server.py \
    --uri 'tcp://0.0.0.0:10400' "$@"
