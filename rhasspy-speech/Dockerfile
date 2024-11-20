FROM debian:bookworm-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install rhasspy-speech
WORKDIR /usr/src
ENV RHASSPY_SPEECH_VERSION=1.0.0
ENV WYOMING_RHASSPY_SPEECH_VERSION=1.0.0

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-dev \
        python3-venv \
        libopenblas0 \
        libencode-perl \
        curl \
        build-essential \
    \
    && mkdir ./tools \
    && curl --location --output - \
        "https://huggingface.co/datasets/rhasspy/rhasspy-speech/resolve/main/tools/rhasspy-speech_${TARGETARCH}${TARGETVARIANT}.tar.gz?download=true" | \
        tar -C ./tools -xzf - \
    && python3 -m venv .venv \
    && .venv/bin/pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && .venv/bin/pip3 install --no-cache-dir \
        --extra-index-url https://www.piwheels.org/simple \
        "rhasspy-speech @ https://github.com/rhasspy/rhasspy-speech/archive/refs/tags/v${RHASSPY_SPEECH_VERSION}.tar.gz" \
        "wyoming-rhasspy-speech @ https://github.com/rhasspy/wyoming-rhasspy-speech/archive/refs/tags/v${WYOMING_RHASSPY_SPEECH_VERSION}.tar.gz" \
    && apt-get remove --yes build-essential \
    && apt-get autoclean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10300

ENTRYPOINT ["bash", "/run.sh"]
