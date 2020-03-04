#!/bin/sh
if [ "x$ROOTFS" == "x" ];then
    ROOTFS=/opt/bsp/HI3531D_BSP/resource/hidoo_third_soft/
fi
if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

SOURCE_PACKAGE="dhcp-4.4.1.tar.gz"
SOURCE_DIR="dhcp-4.4.1"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}

if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
#        rm $SOURCE_PACKAGE  2> /dev/null
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


#source ../common/common.sh

#check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
#check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

if [ ! -d ${SOURCE_DIR} ];then
    tar xvf $SOURCE_PACKAGE
fi

pushd ${SOURCE_DIR}
export CC="$CROSS_COMPILER-gcc -D_GNU_SOURCE"
export BUILD_CC=gcc
export LDFLAGS=-pthread
CHOST=${CROSS_COMPILER} ./configure --prefix=$(pwd)/install --host=arm-linux --with-randomdev=no --enable-dhcpv6=no --with-bind-extra-config="--host=arm --with-randomdev=no --with-openssl=no  --with-libxml2=no --with-zlib=no"
make  && make install
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

popd
