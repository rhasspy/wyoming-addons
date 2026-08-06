#!/usr/bin/env bash
cd /usr/src || exit 1
.venv/bin/python3 /usr/src/tools/stt-fallback/stt_fallback.py \
    --uri 'tcp://0.0.0.0:10300' "$@"
