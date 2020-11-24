# Node.js - QUIC example based docker
## 0. Prerequisites
* [docker](https://docs.docker.com/get-docker/)
* [docker-compose](https://docs.docker.com/compose/install/)

## 1. Get Started
* quic.sh
```shell
./quic.sh --help
./quic.sh all
```

## 2. Server logs
```shell
docker logs node-quic-example -f
```

## 3. Client Echo
```shell
# new terminal
docker exec -i -t node-quic-example bash
node quic-client.js
hello~?
... type anything ...
```

--------------
> [SERVER LOG] node-quic-exmaple  \
> (node:1) ExperimentalWarning: The QUIC protocol is experimental and not yet supported for production use \
> (Use `node --trace-warnings ...` to show where the warning was created) \
> ⭐️ The socket is listening for sessions, on port 1234 \
> [CLIENT] ▶️ hello~?
--------------
> [CLIENT LOG] node-quic-exmaple  \
root@8c032f5210fe:/usr/app# node quic-client.js \
⭐️ The socket is connected with session : node-quic-example:1234 \
(node:54) ExperimentalWarning: The QUIC protocol is experimental and not yet supported for production use \
(Use `node --trace-warnings ...` to show where the warning was created) \
hello~? \
[SERVER] ▶️ Hello Client! \