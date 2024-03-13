ARG BASE=debian:bullseye-slim
FROM $BASE

ARG EXTRA_DEPENDENCIES
ARG RUN_SCRIPT=run-nongpu.sh
ARG TARGETARCH
ARG TARGETVARIANT

# Install Piper
WORKDIR /usr/src
ARG WYOMING_PIPER_VERSION='1.5.0'
ARG BINARY_PIPER_VERSION='1.2.0'

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
        $EXTRA_DEPENDENCIES \
    && pip3 install --no-cache-dir \
        "wyoming-piper @ https://github.com/rhasspy/wyoming-piper/archive/refs/tags/v${WYOMING_PIPER_VERSION}.tar.gz" \
    \
    && curl -L -s \
        "https://github.com/rhasspy/piper/releases/download/v${BINARY_PIPER_VERSION}/piper_${TARGETARCH}${TARGETVARIANT}.tar.gz" \
        | tar -zxvf - -C /usr/share \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY $RUN_SCRIPT ./
ENV RUN_SCRIPT_ENV=$RUN_SCRIPT

EXPOSE 10200

ENTRYPOINT ["bash", "/${RUN_SCRIPT_ENV}"]
