FROM ubuntu:18.04

LABEL maintainer="myeongkil <clevermk7211@gmail.com>"

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt update && \
    apt install -y g++ python ccache build-essential git python3-distutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p build && \
    cd build && \
    git clone https://github.com/nodejs/node.git --depth 1 --branch v15.2.1 && \
    cd node && \
    ./configure --experimental-quic && \
    CC='ccache gcc' CXX='ccache g++' make -j2 && \
    make install PREFIX=/usr/local && \
    rm -rf /build

CMD [ "node" ]