#!/bin/bash

USAGE="Modo de uso: $0 [-g 'x.y.z' -m 'x.y.z' -p '****' ] [-h]      \n
	-u Ghost version                                                \n
	-H MySQL version                                                \n
	-p Ghost port                                                   \n
    -h Mostrar esta ayuda                                           \n
"

GHOST_VERSION=
MYSQL_VERSION=
GHOST_PORT=

function has_command() {
        command -v $1 > /dev/null
}

function processInvocation () {
    while getopts "g:m:p:h" opt; do
        case ${opt} in
            g) GHOST_VERSION=${OPTARG};;
            m) MYSQL_VERSION=${OPTARG};;
            p) GHOST_PORT=${OPTARG};;
            h) echo -e ${USAGE}
                exit 0
                ;;
            *) echo -e ${USAGE} 1>&2
                exit 1
                ;;
        esac
    done

    if [ -z "${GHOST_VERSION}" ] || [ -z "${MYSQL_VERSION}" ] || [ -z "${GHOST_PORT}" ]; then
		echo -e ${USAGE} 1>&2
		exit 1
	fi
}

function ensureVolumesFolders () {
    set -x
    mkdir -p ./docker/volumes/ghost-volumes/${GHOST_VERSION:-latest}
    mkdir -p ./docker/volumes/mysql-volumes/${MYSQL_VERSION:-latest}
    set +x
}

function main () {
    export GHOST_VERSION
    export MYSQL_VERSION
    export GHOST_PORT
    if has_command docker-compose; then
        docker-compose up -d --build
    else
        docker compose up -d --build
    fi
}

processInvocation $@
ensureVolumesFolders
main
