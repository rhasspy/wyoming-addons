# Home Assistant Add-on: Piper

![Supports aarch64 Architecture][aarch64-shield] ![Supports amd64 Architecture][amd64-shield] ![Supports armv7 Architecture][armv7-shield]

Home Assistant add-on that uses [piper](https://github.com/rhasspy/piper/) for text-to-speech.

Part of the [Year of Voice](https://www.home-assistant.io/blog/2022/12/20/year-of-voice/).

Requires Home Assistant 2023.8 or later.

## Running

``` sh
docker run -it -p 10200:10200 -v /path/to/local/data:/data rhasspy/wyoming-piper --voice en_US-lessac-medium
```

The `--voice` argument can be the path to a custom voice file (`<voice>.onnx`). The voice config file must be named `<voice>.onnx.json`

Use `--update-voices` to update the list of available voices.

## HTTP Server

An HTTP server is available on port 5000:

``` sh
docker run -it -p 5000:5000 -p 10200:10200 -v /path/to/local/data:/data rhasspy/wyoming-piper --voice en_US-lessac-medium

```


[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-no-red.svg
[i386-shield]: https://img.shields.io/badge/i386-no-red.svg
