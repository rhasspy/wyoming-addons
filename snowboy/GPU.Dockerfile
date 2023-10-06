FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
ARG TARGETARCH
ARG TARGETVARIANT

# Install wyoming-snowboy
WORKDIR /usr/src
ENV WYOMING_SNOWBOY_VERSION=1.0.0
ENV SNOWMAN_ENROLL_VERSION=1.0.0
ENV PIP_BREAK_SYSTEM_PACKAGES=1

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-dev \
        build-essential \
        swig \
        libatlas-base-dev \
        curl \
    && pip3 install --no-cache-dir -U \
        setuptools \
        wheel \
    && pip3 install --no-cache-dir \
        --extra-index-url https://www.piwheels.org/simple \
        "wyoming-snowboy @ https://github.com/rhasspy/wyoming-snowboy/archive/refs/tags/v${WYOMING_SNOWBOY_VERSION}.tar.gz" \
    && curl --location --output - \
        "https://github.com/rhasspy/snowman-enroll/releases/download/v${SNOWMAN_ENROLL_VERSION}/snowman_enroll-${TARGETARCH}${TARGETVARIANT}.tar.gz" | \
        tar -xzf - \
    && apt-get remove --yes build-essential swig curl \
    && apt-get autoclean \
    && apt-get purge \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY src/train.py /usr/src/
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]

