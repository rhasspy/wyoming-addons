#!/usr/bin/env bash
cd /usr/src || exit 1
.venv/bin/python3 -m speech_to_phrase \
    --uri 'tcp://0.0.0.0:10300' \
    --models-dir /models \
    --train-dir /train \
    --tools-dir ./tools "$@"
