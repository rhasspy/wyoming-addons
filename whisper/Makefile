.PHONY: local run update

VERSION := 2.5.0
TAG := rhasspy/wyoming-whisper
PLATFORMS := linux/amd64,linux/arm64
DATA_DIR := ${HOME}/.local/share/wyoming/whisper
MODEL := tiny-int8
# MODEL := openai/whisper-tiny.en  # needs --use-transformers
MODEL_LANG := en
HOST := 0.0.0.0
PORT := 10300

all:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):$(VERSION)" --push

update:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):latest" --push

local:
	docker build . -t "$(TAG):$(VERSION)" --build-arg TARGETARCH=amd64

run:
	mkdir -p "$(DATA_DIR)"
	docker run -it -p '$(PORT):$(PORT)' -v "$(DATA_DIR):/data" "$(TAG):$(VERSION)" --model "$(MODEL)" --language "$(MODEL_LANG)" --uri 'tcp://$(HOST):$(PORT)' --debug
