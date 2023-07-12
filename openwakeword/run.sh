#!/usr/bin/env bash
python3 -m wyoming_openwakeword \
    --uri 'tcp://0.0.0.0:10400' "$@"
