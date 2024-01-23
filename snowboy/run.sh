#!/usr/bin/env bash
set -e

cd /usr/src

snowboy_args=();
train_args=()

while [ -n "$1" ]; do
    if [ "$1" = '--train-dir' ]; then
        shift
        train_dir="$1"
    else
        snowboy_args+=("$1")
        if [ "$1" == '--debug' ]; then
            train_args+=("$1")
        fi
    fi

    shift
done

# Train models in a directory with the structure:
# <train_dir>/
#   <language>/
#     <wake_word>/
#       sample1.wav
#       ...
#
# When trained, a .pmdl file with the same name as the directory will be
# present.
if [ -n "${train_dir}" ]; then
    .venv/bin/python3 train.py \
        --train-dir "${train_dir}" \
        --snowman-dir . "${train_args[@]}"
fi

.venv/bin/python3 -m wyoming_snowboy \
    --uri 'tcp://0.0.0.0:10400' "${snowboy_args[@]}"
