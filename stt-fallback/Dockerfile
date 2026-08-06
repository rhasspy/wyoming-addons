FROM debian:trixie-slim
ARG TARGETARCH
ARG TARGETVARIANT

# Install stt-fallback
# The hassio-addons repo is not tagged, so the source is pinned by commit.
WORKDIR /usr/src
ENV COMMIT=f3ed8114eddc11382552e1c3a4329c0b7c823ce4

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        curl \
    \
    && mkdir -p ./tools/stt-fallback \
    && curl --location --output ./tools/stt-fallback/stt_fallback.py \
        "https://raw.githubusercontent.com/rhasspy/hassio-addons/${COMMIT}/stt-fallback/src/stt_fallback.py" \
    && curl --location --output ./tools/stt-fallback/requirements.txt \
        "https://raw.githubusercontent.com/rhasspy/hassio-addons/${COMMIT}/stt-fallback/requirements.txt" \
    && python3 -m venv .venv \
    && .venv/bin/pip3 install --no-cache-dir \
        -r ./tools/stt-fallback/requirements.txt \
    && apt-get remove --yes curl \
    && apt-get autoremove --yes \
    && apt-get clean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10300

ENTRYPOINT ["bash", "/run.sh"]
