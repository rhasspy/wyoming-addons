.PHONY: local run update

VERSION := 1.1.0
TAG := rhasspy/wyoming-whisper-cpp
PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7
HOST := 0.0.0.0
PORT := 10300
DATA_DIR := $(PWD)/local

all:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):$(VERSION)" --push

update:
	docker buildx build . --platform "$(PLATFORMS)" --tag "$(TAG):latest" --push

local:
	docker build . -t "$(TAG):$(VERSION)" --build-arg TARGETARCH=amd64

run:
	docker run -it -p "$(PORT):$(PORT)" -v "$(DATA_DIR):$(DATA_DIR)" "$(TAG):$(VERSION)" --uri 'tcp://$(HOST):$(PORT)' --data-dir "$(DATA_DIR)" --model 'tiny.en-q5_1' --debug
