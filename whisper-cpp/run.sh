#!/usr/bin/env bash
python3 -m wyoming_whisper_cpp \
    --whisper-cpp-dir '/usr/share/wyoming-whisper-cpp/whisper.cpp' \
    --uri 'tcp://0.0.0.0:10300' "$@"
