FROM ubuntu:jammy

RUN apt-get update && apt-get install -y \
    curl \
    file \
    git \
    unzip \
    xz-utils \
    zip \
    clang \
    cmake \
    ninja-build \
    build-essential \
    pkg-config \
    libgtk-3-dev \
    liblzma-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/

RUN git clone https://github.com/flutter/flutter.git -b stable

ENV PATH $PATH:PATH:/usr/local/flutter/bin

ARG USERNAME=user

ARG GROUPNAME=user

ARG UID=1000

ARG GID=1000

RUN groupadd -g $GID $GROUPNAME \
    && useradd -m -s /bin/bash -u $UID -g $GID $USERNAME

RUN chown -R 1000:1000 /usr/local/flutter
