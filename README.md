# Wyoming Add-ons

Docker-only builds for Home Assistant add-ons that use the [Wyoming protocol](https://github.com/rhasspy/rhasspy3/blob/master/docs/wyoming.md), specifically:

* [Whisper](https://hub.docker.com/r/rhasspy/wyoming-whisper) ([Add-on](https://github.com/home-assistant/addons/blob/master/whisper/README.md))
* [Piper](https://hub.docker.com/r/rhasspy/wyoming-piper) ([Add-on](https://github.com/home-assistant/addons/blob/master/piper/README.md))
* [openWakeWord](https://hub.docker.com/r/rhasspy/wyoming-openwakeword) ([Add-on](https://github.com/home-assistant/addons/blob/master/openwakeword/README.md))
* [snowboy](https://hub.docker.com/r/rhasspy/wyoming-snowboy) ([Add-on](https://github.com/rhasspy/hassio-addons/tree/master/snowboy/README.md))
* [microWakeWord](https://hub.docker.com/r/rhasspy/wyoming-microwakeword) ([Add-on](https://github.com/rhasspy/hassio-addons/tree/master/microwakeword/README.md))
* [rhasspy-speech](https://hub.docker.com/r/rhasspy/wyoming-rhasspy-speech) ([Add-on](https://github.com/rhasspy/hassio-addons/tree/master/rhasspy-speech/README.md))


## Run Whisper

``` sh
docker run -it -p 10300:10300 -v /path/to/local/data:/data rhasspy/wyoming-whisper --model tiny-int8 --language en
```


## Run Piper

``` sh
docker run -it -p 10200:10200 -v /path/to/local/data:/data rhasspy/wyoming-piper --voice en_US-lessac-medium
```


## Run openWakeWord

``` sh
docker run -it -p 10400:10400 rhasspy/wyoming-openwakeword --preload-model 'ok_nabu'
```


## Run snowboy

``` sh
docker run -it -p 10400:10400 rhasspy/wyoming-snowboy
```


## Run microWakeWord

``` sh
docker run -it -p 10400:10400 rhasspy/wyoming-microwakeword
```


## Run rhasspy-speech

``` sh
docker run -it -p 10300:10300 -v /path/to/download/models:/models -v /path/to/train:/train rhasspy/wyoming-rhasspy-speech
```


## To run in standalone server

### Run without GPU

Build openwakeword, piper and whisper without GPU with:

``` sh
docker compose -f docker-compose.base.yml build --no-cache
```

Run it with:

``` sh
docker compose -f docker-compose.base.yml up -d
```

Take it down with:

``` sh
docker compose down
```

### Run with GPU

Build openwakeword, piper and whisper with GPU with:

``` sh
docker compose -f docker-compose.gpu.yml build --no-cache
```

Run it with:

``` sh
docker compose -f docker-compose.gpu.yml up -d
```

Take it down with:

``` sh
docker compose down
```

### Extend it

You can extend those files adding your own languages.
More on docker compose extend in the [official documentation](https://docs.docker.com/compose/multiple-compose-files/extends/).

