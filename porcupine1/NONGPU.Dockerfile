FROM debian:bookworm-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install porcupine1
WORKDIR /usr/src
ENV WYOMING_PORCUPINE1_VERSION=1.2.0

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
    \
    && python3 -m venv .venv \
    && .venv/bin/pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && .venv/bin/pip3 install --no-cache-dir \
        --extra-index-url https://www.piwheels.org/simple \
        "wyoming-porcupine1 @ https://github.com/rhasspy/wyoming-porcupine1/archive/refs/tags/v${WYOMING_PORCUPINE1_VERSION}.tar.gz" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
