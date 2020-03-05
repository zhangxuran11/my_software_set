#!/bin/sh

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

SOURCE_DIR=live
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
        sudo rm $SOURCE_DIR -r  2>/dev/null
        ;;
    install)          
        pushd ${SOURCE_DIR_FULL_PATH}
        SYSROOT=$(${CROSS_COMPILER}-gcc --print-sysroot)
        if [ "x"${SYSROOT} != "x" ];then
            sudo cp install/* ${SYSROOT}/ -rfd
        fi
        if [ "x"${ROOTFS} != "x" ];then
            echo "ok"
            #cp install/*      ${ROOTFS}/ -rfd #全是静态库，不需要复制到文件系统
        fi
        popd
        ;;
    force)
        ./build.sh clean
        ./build.sh
        ;;
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi

if [ ! -d ${SOURCE_DIR} ];then
    tar xvf live.2020.02.25.tar.gz
    cp config.arm-hisiv500 ${SOURCE_DIR}
fi


pushd ${SOURCE_DIR}
./genMakefiles arm-hisiv500
make && make install
popd
