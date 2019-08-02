#!/bin/sh

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

SOURCE_PACKAGE="openssh-8.0p1.tar.gz"
SOURCE_DIR="openssh-8.0p1"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.0p1.tar.gz"
SOURCE_SHA256SUM="bd943879e69498e8031eb6b7f44d08cdc37d59a7ab689aa0b437320c3481fd68"

if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
        rm $SOURCE_DIR -r  2> /dev/null
        exit 0
        ;;
    install)
        cp sshd_config ${SOURCE_DIR_FULL_PATH}/install/etc/ssh/
        pushd ${SOURCE_DIR_FULL_PATH}
        SYSROOT=$(${CROSS_COMPILER}-gcc --print-sysroot)
        if [ "x"${SYSROOT} != "x" ];then
            sudo ls -I bin install   | xargs  -i cp  install/{} ${SYSROOT}/
        fi
        if [ "x"${ROOTFS} != "x" ];then
            cp install/*      ${ROOTFS}/ -rfd
        fi
        popd
        exit 0
        ;;
    *)
        echo './build.sh clean|install'
  esac

fi

source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

pushd ${SOURCE_DIR}

if [ "$1" == "force" ];then
    rm install -rf
    make distclean
fi
autoheader
autoconf
./configure --prefix=/ --host=${CROSS_COMPILER}  --with-privsep-path=/var/empty --without-pam --disable-strip --disable-static --sysconfdir=/etc/ssh   --exec-prefix=/
#./configure --prefix=${SOURCE_DIR_FULL_PATH}/install --host=${CROSS_COMPILER}    --without-pam --disable-strip --disable-static 

if [ $(cat includes.h | wc -l) == 179 ];then
    sed -i 'N;18a\#include <stdarg.h>  //zxr' includes.h   # 在arm-hisiv500-linux(uclibc)环境下报错，找不到va_list类型
fi

make -j && make install-nokeys DESTDIR=${SOURCE_DIR_FULL_PATH}/install
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

popd
