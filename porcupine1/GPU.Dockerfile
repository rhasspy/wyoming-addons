FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04
ARG TARGETARCH
ARG TARGETVARIANT

# Install porcupine1
WORKDIR /usr/src
ENV PIP_BREAK_SYSTEM_PACKAGES=1

COPY ./src/ ./

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
        'numpy<1.26' \
        -r requirements.txt \
    \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /
COPY run.sh ./

EXPOSE 10400

ENTRYPOINT ["bash", "/run.sh"]
