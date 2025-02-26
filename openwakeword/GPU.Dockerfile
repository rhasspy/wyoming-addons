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
        libopenblas0 \
    \
    && pip3 install --no-cache-dir uv \
    && uv pip install --system --no-cache-dir -U \
        setuptools \
        wheel \
    && uv pip install --system --no-cache-dir \
        "wyoming-openwakeword==${WYOMING_OPENWAKEWORD_VERSION}" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
