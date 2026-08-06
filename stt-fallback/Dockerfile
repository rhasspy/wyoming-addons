FROM debian:trixie-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install stt-fallback
WORKDIR /usr/src
ENV STT_FALLBACK_VERSION=1.0.0
ENV COMMIT=f3ed8114eddc11382552e1c3a4329c0b7c823ce4

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-dev \
        python3-venv \
        curl \
        libarchive-tools \
    \
    && mkdir ./tools \
    && curl --location --output - \
        "https://github.com/rhasspy/hassio-addons/archive/${COMMIT}.zip" | \
        bsdtar -C ./tools -xf - \
    && mv ./tools/hassio-addons-${COMMIT}/stt-fallback/src ./tools/stt-fallback \
    && mv ./tools/hassio-addons-${COMMIT}/stt-fallback/requirements.txt ./tools/stt-fallback \
    && rm -rf ./tools/hassio-addons-${COMMIT} \
    && python3 -m venv .venv \
    && .venv/bin/pip3 install --no-cache-dir \
        -r ./tools/stt-fallback/requirements.txt \
    && apt-get remove --yes build-essential libarchive-tools curl \
    && apt-get autoremove --yes \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10300

ENTRYPOINT ["bash", "/run.sh"]
