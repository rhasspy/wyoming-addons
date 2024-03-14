ARG BASE=debian:bookworm-slim
FROM $BASE

ARG EXTRA_DEPENDENCIES
ARG RUN_SCRIPT='run-nongpu.sh'
ARG TARGETARCH
ARG TARGETVARIANT

# Install Piper
WORKDIR /usr/src
ARG WYOMING_PIPER_VERSION='1.5.0'
ARG BINARY_PIPER_VERSION='1.2.0'

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        wget \
        curl \
        python3 \
        python3-pip \
    \
    && rm -rf /var/lib/apt/lists/*

RUN \
    pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
        $EXTRA_DEPENDENCIES \
    \
    && wget https://github.com/rhasspy/piper-phonemize/releases/download/v1.1.0/piper_phonemize-1.1.0-cp39-cp39-manylinux_2_28_x86_64.whl \
    \
    && mv piper_phonemize-1.1.0-cp39-cp39-manylinux_2_28_x86_64.whl piper_phonemize-1.1.0-py3-none-any.whl \
    \
    && pip3 install --no-cache-dir --force-reinstall --no-deps \
        "piper-tts==${BINARY_PIPER_VERSION}" \
    \
    && pip3 install --no-cache-dir --force-reinstall --no-deps \
        piper_phonemize-1.1.0-py3-none-any.whl \
    \
    && pip3 install --no-cache-dir \
        "wyoming-piper @ https://github.com/rhasspy/wyoming-piper/archive/refs/tags/v${WYOMING_PIPER_VERSION}.tar.gz" \
    \
    && rm -r piper_phonemize-1.1.0-py3-none-any.whl

WORKDIR /
COPY $RUN_SCRIPT ./
ENV RUN_SCRIPT_ENV="/${RUN_SCRIPT}"

EXPOSE 10200

ENTRYPOINT ["bash", "-c", "exec $RUN_SCRIPT_ENV \"${@}\"", "--"]
