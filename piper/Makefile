.PHONY: local run

TAG := rhasspy/wyoming-piper
PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7
DATA_DIR := ${HOME}/.local/share/wyoming/piper
VOICE := en-us-lessac-medium
HOST := 0.0.0.0
PORT := 10200

all:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG)" --push

local:
	docker build . -t "$(TAG)" --build-arg TARGETARCH=amd64

run:
	mkdir -p "$(DATA_DIR)"
	docker run -it -p '$(PORT):$(PORT)' -v "$(DATA_DIR):/data"  "$(TAG)" --voice "$(VOICE)" --uri 'tcp://$(HOST):$(PORT)' --debug
