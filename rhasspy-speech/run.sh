#!/usr/bin/env bash
cd /usr/src
.venv/bin/python3 -m wyoming_rhasspy_speech \
    --uri 'tcp://0.0.0.0:10300' \
    --web-server-host '0.0.0.0' \
    --models-dir /models \
    --train-dir /train \
    --tools-dir ./tools "$@"
