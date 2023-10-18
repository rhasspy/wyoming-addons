# snowboy

Wyoming server that uses [snowboy](https://github.com/Kitt-AI/snowboy) for wake word detection and [snowman](https://github.com/Thalhammer/snowman/) for custom wake word training.

## Custom Wake Words

This container will train custom wake words on start-up if `--train-dir <TRAIN_DIR>` is provided. Make sure to add `-v <TRAIN_DIR>:<TRAIN_DIR>` to your `docker run` command to give the container access.

Place WAV audio samples in `<TRAIN_DIR>/<language>/<wake_word>`

To get started, first record 3 samples of your wake word:

```sh
arecord -r 16000 -c 1 -f S16_LE -t wav -d 3 sample1.wav
arecord -r 16000 -c 1 -f S16_LE -t wav -d 3 sample2.wav
arecord -r 16000 -c 1 -f S16_LE -t wav -d 3 sample3.wav
```

Ideally, this should be recorded on the same device you plan to use for wake word recognition (same microphone, etc).

Copy the WAV files to `<TRAIN_DIR>/<language>/<wake_word>` where `<language>` is either `en` for English or `zh` for Chinese (other languages are not supported). `<wake_word>` should be the name of your wake word, such as `hey_computer` (spaces in the same are not recommended).

Your directory structure should look like this after copying the samples:

- `<TRAIN_DIR>`
    - `en/`
        - `hey_computer/`
            - `sample1.wav`
            - `sample2.wav`
            - `sample3.wav`

Start the container and check the log output for a message that your wake word was trained. Add `--debug` to see more information.

After training, your wake word model (`.pmdl`) will be next to your samples:

- `<TRAIN_DIR>`
    - `en/`
        - `hey_computer/`
            - `hey_computer.pmdl`
            - `sample1.wav`
            - `sample2.wav`
            - `sample3.wav`
            
Custom wake words can be enabled with `--custom-model-dir <CUSTOM_DIR>` where `<CUSTOM_DIR>` is a directory with `.pmdl` files.
Copy your wake word model (e.g., `hey_computer.pmdl`) to `<CUSTOM_DIR>` to start using it immediately.

If you'd like to retrain, delete the `.pmdl` file next to your samples and restart the container. You will need to copy the new model to `<CUSTOM_DIR>` again after training.
