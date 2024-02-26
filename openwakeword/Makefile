.PHONY: local run update

VERSION := 1.10.0
TAG := rhasspy/wyoming-openwakeword
PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7
MODEL := "ok_nabu"
HOST := 0.0.0.0
PORT := 10400

all:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):$(VERSION)" --push

update:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):latest" --push

local:
	docker build . -t "$(TAG):$(VERSION)" --build-arg TARGETARCH=amd64

run:
	docker run -it -p '$(PORT):$(PORT)' "$(TAG):$(VERSION)" --preload-model "$(MODEL)" --uri 'tcp://$(HOST):$(PORT)' --debug
