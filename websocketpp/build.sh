#!/bin/sh
if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi
SOURCE_PACKAGE="websocketpp-0.8.1.tar"
SOURCE_DIR="websocketpp-0.8.1"
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://github.com/zaphoyd/websocketpp.git"


if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
        rm $SOURCE_DIR -r  
        ;;
    install)          
        pushd ${SOURCE_DIR_FULL_PATH}
        SYSROOT=$(${CROSS_COMPILER}-gcc --print-sysroot)
        if [ "x"${SYSROOT} != "x" ];then
            sudo cp install/* ${ROOTFS}/ -rfd
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
if [ ! -d ${SOURCE_DIR} ];then
    tar xvf ${SOURCE_PACKAGE}
    mkdir ${SOURCE_DIR}/build
    cp ${CROSS_COMPILER}.cmake ${SOURCE_DIR}/build/cross.cmake
    sed -i '8i\include(${CMAKE_CURRENT_SOURCE_DIR}/build/cross.cmake)' ${SOURCE_DIR}/CMakeLists.txt
fi
pushd ${SOURCE_DIR}/build
cmake  .. && make
#make install
popd
