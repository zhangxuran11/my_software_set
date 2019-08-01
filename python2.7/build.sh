#!/bin/bash


SOURCE_PACKAGE="Python-2.7.16.tgz"
SOURCE_DIR="Python-2.7.16"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://www.python.org/ftp/python/2.7.16/Python-2.7.16.tgz"
SOURCE_SHA256SUM="01da813a3600876f03f46db11cc5c408175e99f03af2ba942ef324389a83bad5"


if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
        rm $SOURCE_PACKAGE  2> /dev/null
        rm $SOURCE_DIR -r  2> /dev/null
        ;;
    install)          
        pushd ${SOURCE_DIR_FULL_PATH}
        SYSROOT=$(${CROSS_COMPILER}-gcc --print-sysroot)
        if [ "x"${SYSROOT} != "x" ];then
            sudo cp install/* ${SYSROOT}/ -rfd
        fi
        if [ "x"${ROOTFS} != "x" ];then
            cp install/*      ${ROOTFS}/ -rfd
        fi
        popd
        ;;
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

pushd ${SOURCE_DIR}
CC=${CROSS_COMPILER}-gcc CXX=${CROSS_COMPILER}-g++ ./configure --host=arm-hisiv500-linux-gnu --build=arm --prefix=${SOURCE_DIR_FULL_PATH}/install  --disable-ipv6 ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no
make -j
make install

popd

