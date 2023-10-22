#!/usr/bin/env bash
python3 -m wyoming_vosk \
    --uri 'tcp://0.0.0.0:10300' "$@"
