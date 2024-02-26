.PHONY: local run update

VERSION := 1.5.0
TAG := rhasspy/wyoming-piper
PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7
DATA_DIR := ${HOME}/.local/share/wyoming/piper
VOICE := en_US-lessac-medium
HOST := 0.0.0.0
PORT := 10200

all:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):$(VERSION)" --push

update:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):latest" --push

local:
	docker build . -t "$(TAG):$(VERSION)" --build-arg TARGETARCH=amd64

run:
	mkdir -p "$(DATA_DIR)"
	docker run -it -p '$(PORT):$(PORT)' -v "$(DATA_DIR):/data"  "$(TAG):$(VERSION)" --voice "$(VOICE)" --uri 'tcp://$(HOST):$(PORT)' --debug
