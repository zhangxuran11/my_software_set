#!/bin/sh

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

SOURCE_PACKAGE="libwebsockets-v3.1-stable.tar.xz"
SOURCE_DIR="libwebsockets-v3.1-stable"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://libwebsockets.org/git/libwebsockets/snapshot/libwebsockets-v3.1-stable.tar.xz"
SOURCE_SHA256SUM="590058463fd8506135ec42704fe22d2555da4037ebc5a0464d99fda92a97efca"

if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
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
    force)
        ./build.sh clean
        ./build.sh
        ;;
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi


source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
#check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

if [ ! -d ${SOURCE_DIR} ];then
    tar xvf ${SOURCE_PACKAGE}
    mkdir ${SOURCE_DIR}/build
    cp ${CROSS_COMPILER}.cmake ${SOURCE_DIR}/build/cross.cmake
    sed -i '7i\include(${CMAKE_CURRENT_SOURCE_DIR}/build/cross.cmake)' ${SOURCE_DIR}/CMakeLists.txt
    cmake --version > /dev/null
    if [ $? != 0 ];then
        sudo apt install cmake
    fi
fi

pushd ${SOURCE_DIR}/build
cmake -DCMAKE_BUILD_TYPE=Debug  ..  && make -j && make install
#make -j && make install
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

popd
