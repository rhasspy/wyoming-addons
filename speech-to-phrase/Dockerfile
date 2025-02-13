FROM debian:bookworm-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install speech-to-phrase
WORKDIR /usr/src
ENV SPEECH_TO_PHRASE_VERSION=1.2.0

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
    && .venv/bin/pip3 install --no-cache-dir \
        "speech-to-phrase @ https://github.com/OHF-Voice/speech-to-phrase/archive/refs/tags/v${SPEECH_TO_PHRASE_VERSION}.tar.gz" \
    && apt-get remove --yes build-essential \
    && apt-get autoclean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10300

ENTRYPOINT ["bash", "/run.sh"]
