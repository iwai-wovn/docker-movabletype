#!/bin/bash

MT_PATH=${MT_PATH:-/var/www/cgi-bin/mt}
DL_FILE=mt${MT_VERSION}.tar.gz
SRC_PATH=/usr/local/src

if [ ! -e "${MT_PATH}/mt.cgi" ]; then

    if [ ! -e "${SRC_PATH}/${DL_FILE}" ]; then
        echo Download MovableType ${MT_VERSION} - downloading now...
        curl -Ss -L https://github.com/movabletype/movabletype/archive/${DL_FILE} -o ${SRC_PATH}/${DL_FILE}
    fi

    echo MovableType not found in ${MT_PATH} - copying now...

    mkdir -p ${MT_PATH}
    tar zxf ${SRC_PATH}/${DL_FILE} -C ${MT_PATH} --strip-components 1
    chmod -R a+w ${MT_PATH}/mt-static/support

    echo Complete! MovableType has been successfully copied to ${MT_PATH}
fi

exec "$@"
