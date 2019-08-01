#!/bin/bash

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi


SOURCE_PACKAGE="boost_1_70_0.tar.bz2"
SOURCE_DIR="boost_1_70_0"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://dl.bintray.com/boostorg/release/1.70.0/source/${SOURCE_PACKAGE}"
SOURCE_SHA256SUM="430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"

source ../common/common.sh

if [ $# == 1 ];then
	if [ "x"$1 == "xclean" ];then
        rm index* 2>/dev/null
        rm ${SOURCE_DIR} -rf 2>/dev/null      
        rm ${SOURCE_PACKAGE} -rf 2>/dev/null
        exit 0
	fi
fi

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}


pushd boost_1_70_0

./bootstrap.sh --prefix=./install --without-libraries=python
if [ "x${CROSS_COMPILER}" != "x" ];then
    echo ${CROSS_COMPILER}
    sed  -i "s/using gcc ;/using gcc : 4.9.4  : ${CROSS_COMPILER}-g++ ;/g" project-config.jam
fi
./bjam --with-system --with-thread --without-python 
./b2
./b2 install --prefix=./install
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
