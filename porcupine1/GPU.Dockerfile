FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
ARG TARGETARCH
ARG TARGETVARIANT

# Install porcupine1
WORKDIR /usr/src
ENV WYOMING_PORCUPINE1_VERSION=1.0.1
ENV PIP_BREAK_SYSTEM_PACKAGES=1

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
        --extra-index-url https://www.piwheels.org/simple \
        "wyoming-porcupine1==${WYOMING_PORCUPINE1_VERSION}" \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
