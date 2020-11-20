# Node.js - QUIC example based docker

## 0. Prerequisites
* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)

## 1. Get Started
* quic.sh
```shell
./quic.sh --help
./quic.sh build
./quic.sh all
```

```shell
docker run -it -w /usr/app -v $PWD/src:/usr/app node-quic-example bash
node quic-client.js
```

## 2. Server logs
```shell
docker logs node-quic-server
```