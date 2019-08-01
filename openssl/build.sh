#!/bin/sh

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv600-linux
fi

SOURCE_PACKAGE="openssl-1.0.2s.tar.gz"
SOURCE_DIR="openssl-1.0.2s"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="http://distfiles.macports.org/openssl/openssl-1.0.2s.tar.gz"
SOURCE_SHA256SUM="cabd5c9492825ce5bd23f3c3aeed6a97f8142f606d893df216411f07d1abab96"

if [ "x"$1 == "xclean" ];then
    rm $SOURCE_PACKAGE  2> /dev/null
    rm $SOURCE_DIR -r  2> /dev/null

    exit 0
fi

source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

pushd ${SOURCE_DIR}
./Configure  -no-ssl3 shared --prefix=${SOURCE_DIR_FULL_PATH}/install  linux-armv4 --cross-compile-prefix=${CROSS_COMPILER}-
make depend && make -j && make install
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

SYSROOT=$(${CROSS_COMPILER}-gcc --print-sysroot)
if [ "x"${SYSROOT} != "x" ];then
    sudo cp install/include/* ${SYSROOT}/usr/include -rfd
    sudo cp install/lib/*      ${SYSROOT}/usr/lib -rfd
fi
if [ "x"${ROOTFS} != "x" ];then
    cp install/* ${ROOTFS}/ -rfd
fi
popd
