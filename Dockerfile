FROM ubuntu:20.04
RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt update && \
    apt install -y build-essential g++ ccache python python3-distutils git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# https://github.com/nodejs/quic.git
# Author: Daniel Bevenius <daniel.bevenius@gmail.com>
# Date:   Fri May 8 06:27:58 2020 +0200
ENV GIT_COMMIT_REVISION=5baab3f3a05548d3b51bea98868412b08766e34d

RUN mkdir -p /tmp/src/github.com/nodejs && \
    cd /tmp/src/github.com/nodejs && \
    git clone https://github.com/nodejs/quic.git && \
    cd quic && \
    git reset --hard $GIT_COMMIT_REVISION && \
    ./configure --experimental-quic && \
    CC='ccache gcc' CXX='ccache g++' make -j2 && \
    make install PREFIX=/usr/local && \
    rm -rf /tmp/src