.PHONY: local run

TAG := rhasspy/wyoming-whisper
DATA_DIR := ${HOME}/.local/share/wyoming/whisper
MODEL := tiny-int8
MODEL_LANG := en
HOST := 0.0.0.0
PORT := 10300

all:
	docker buildx build . --platform linux/amd64,linux/arm64 --tag "$(TAG)" --push

local:
	docker build . -t "$(TAG)"

run:
	mkdir -p "$(DATA_DIR)"
	docker run -it -p '$(PORT):$(PORT)' -v "$(DATA_DIR):/data" "$(TAG)" --model "$(MODEL)" --language "$(MODEL_LANG)" --uri 'tcp://$(HOST):$(PORT)'
