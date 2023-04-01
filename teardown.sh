#!/bin/bash

USAGE="Modo de uso: $0 [-g 'x.y.z' -m 'x.y.z'] [-h]     \n
	-u Ghost version                                    \n
	-H MySQL version                                    \n
    -h Mostrar esta ayuda                               \n
"

GHOST_VERSION=
MYSQL_VERSION=

function processInvocation () {
    while getopts "g:m:h" opt; do
        case ${opt} in
            g) GHOST_VERSION=${OPTARG};;
            m) MYSQL_VERSION=${OPTARG};;
            h) echo -e ${USAGE}
                exit 0
                ;;
            *) echo -e ${USAGE} 1>&2
                exit 1
                ;;
        esac
    done

    if [ -z "${GHOST_VERSION}" ] || [ -z "${MYSQL_VERSION}" ]; then
		echo -e ${USAGE} 1>&2
		exit 1
	fi
}

function deleteVolumesFolders () {
    echo 'Va a pedir contraseña para borrar los volumes ./docker/volumes/ghost-volumes & ./docker/volumes/mysql-volumes/'
    set -x
    sudo rm -rf "./docker/volumes/ghost-volumes/${GHOST_VERSION:-latest}"
    sudo rm -rf "./docker/volumes/mysql-volumes/${MYSQL_VERSION:-latest}"
    set +x
}

function main () {
    export GHOST_VERSION
    export MYSQL_VERSION
    docker-compose down -v --rmi all
}

processInvocation $@
main
deleteVolumesFolders
