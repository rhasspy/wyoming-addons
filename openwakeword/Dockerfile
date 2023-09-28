FROM debian:bullseye-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install openWakeWord
WORKDIR /usr/src
ARG OPENWAKEWORD_LIB_VERSION='1.5.1'

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
    \
    && pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir \
        "wyoming-openwakeword==${OPENWAKEWORD_LIB_VERSION}" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
