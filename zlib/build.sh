#!/bin/sh

CROSS_COMPILER=arm-hisiv500-linux

SOURCE_PACKAGE="zlib-1.2.11.tar.xz"
SOURCE_DIR="zlib-1.2.11"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="http://www.zlib.net/zlib-1.2.11.tar.xz"
SOURCE_SHA256SUM="4ff941449631ace0d4d203e3483be9dbc9da454084111f97ea0a2114e19bf066"

if [ "x"$1 == "xclean" ];then
    rm $SOURCE_PACKAGE  2> /dev/null
    rm $SOURCE_DIR -r  2> /dev/null

    exit 0
fi

source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}

check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

pushd ${SOURCE_DIR}
CHOST=${CROSS_COMPILER} ./configure  --prefix=${SOURCE_DIR_FULL_PATH}/install  --shared
make -j
make install
popd
