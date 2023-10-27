FROM debian:bullseye-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install openWakeWord
WORKDIR /usr/src
ARG OPENWAKEWORD_LIB_VERSION='1.8.1'

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        libopenblas0 \
    \
    && pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir \
        --extra-index-url https://www.piwheels.org/simple \
        "wyoming-openwakeword==${OPENWAKEWORD_LIB_VERSION}" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
