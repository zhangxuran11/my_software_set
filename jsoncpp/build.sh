#!/bin/sh

#对于arm-hisiv500-linux编译环境，需要在 /opt/hisi-linux/x86-arm/arm-hisiv500-linux/arm-hisiv500-linux-uclibcgnueabi/include/c++/4.9.4/cstdio 加入snprintf

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi
SOURCE_PACKAGE="jsoncpp-1.8.4.zip"
SOURCE_DIR="jsoncpp-1.8.4"
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}

if [ ! -d $SOURCE_DIR ] ;then
    unzip ${SOURCE_DIR}
fi

grep "cross.cmake" $SOURCE_DIR_FULL_PATH/CMakeLists.txt
if [ $? == 1 ];then
    mkdir ${SOURCE_DIR}/build
    cp ${CROSS_COMPILER}.cmake ${SOURCE_DIR}/build/cross.cmake
    sed -i '1i\include(${CMAKE_CURRENT_SOURCE_DIR}/build/cross.cmake)' ${SOURCE_DIR}/CMakeLists.txt
fi
pushd ${SOURCE_DIR}/build
cmake  .. && make
make install
popd
