#!/bin/bash
rootdir="$( cd "$(dirname "$0")" ; pwd -P )"
bdir=$rootdir/build
sdir=$rootdir/src
net=quic_test_net

cecho(){
    RED="\033[1;31m"
    GREEN="\033[0;32m"
    YELLOW="\033[0;33m"
    BLUE="\033[1;34m"
    DARKGRAY="\033[0;90m"
    NC="\033[0m"
    str="${@:2:${#@}}"
    printf "${!1}${str}  ${NC}\n"
}

function quic_usage {
    cecho "BLUE"  "-------------------------------------------------------------------------"
    cecho "DARKGRAY"   "                        Node.js QUIC docker example "
    cecho "BLUE"  "-------------------------------------------------------------------------"
    cecho "BLUE"  " Commands"
    cecho "GREEN" " - all       : clean && build && up"
    cecho "GREEN" " - clean     : server down && remove build directory and docker image"
    cecho "GREEN" " - build     : generate dummy_certs && copy code && build docker image"
    cecho "GREEN" " - up        : QUIC server docker up"
    cecho "GREEN" " - down      : QUIC server docker down"
    cecho "BLUE"  "-------------------------------------------------------------------------"
}

function quic_build {
    mkdir -p $bdir/ssl_certs && \
    cd $bdir/ssl_certs && \
    openssl genrsa 2024 > server.key && \
    openssl req -new -key server.key -subj "/C=KR" > server.csr && \
    openssl x509 -req -days 3650 -signkey server.key < server.csr > server.crt

    cp $sdir/quic-client.js $bdir/
    cp $sdir/quic-server.js $bdir/

    cd $rootdir && \
    docker build . -t node-quic-example:latest
}

function quic_up {
    docker network inspect $net >/dev/null 2>&1 || docker network create --driver bridge $net
    docker-compose up -f $rootdir/docker-compose.yaml -d
}

function quic_down {
    docker-compose down -f $rootdir/docker-compose.yaml -v
    docker network rm $net >/dev/null 2>&1
}

function quic_clean {
    quic_down
    rm -rf $bdir
    docker image rm $(docker images --format '{{.Repository}}:{{.Tag}}' | grep quic-) >/dev/null 2>&1
}

function quic_all {
    quic_clean
    build
    quic_up
}

function main {
    case $1 in
        all | build | up | down | clean)
            cmd=quic_$1
            shift
			$cmd $@
            ;;
        *)
            quic_usage
			exit
            ;;
    esac
}

main $@