FROM debian:bookworm-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install Piper
WORKDIR /usr/src
ARG WYOMING_PIPER_VERSION='1.5.4'
ARG BINARY_PIPER_VERSION='1.2.0'
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        python3 \
        python3-pip \
    \
    && pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir \
        "wyoming-piper @ https://github.com/rhasspy/wyoming-piper/archive/refs/tags/v${WYOMING_PIPER_VERSION}.tar.gz" \
    \
    && pip3 install --no-cache-dir \
        'wyoming[http] @ https://github.com/OHF-voice/wyoming/archive/refs/tags/1.6.2.tar.gz' \
    \
    && curl -L -s \
        "https://github.com/rhasspy/piper/releases/download/v${BINARY_PIPER_VERSION}/piper_${TARGETARCH}${TARGETVARIANT}.tar.gz" \
        | tar -zxvf - -C /usr/share \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10200
EXPOSE 5000

ENTRYPOINT ["bash", "/run.sh"]
