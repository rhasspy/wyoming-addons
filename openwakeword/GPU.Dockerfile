ARG BASE=debian:bookworm-slim
FROM $BASE

ARG TARGETARCH
ARG TARGETVARIANT

# Install openWakeWord
WORKDIR /usr/src
ARG WYOMING_OPENWAKEWORD_VERSION='1.8.2'

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        libopenblas0 \
    \
    && python3 -m venv .venv \
    && .venv/bin/pip3 install --no-cache-dir uv \
    && .venv/bin/uv pip install --no-cache-dir -U \
        setuptools \
        wheel \
    && .venv/bin/uv pip install --no-cache-dir \
        --exclude-newer 2023-12-12 \
        "wyoming-openwakeword==${WYOMING_OPENWAKEWORD_VERSION}" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
