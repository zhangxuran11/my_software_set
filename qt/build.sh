#!/bin/sh

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi

SOURCE_PACKAGE="qt-everywhere-opensource-src-5.7.1.tar.xz"
SOURCE_DIR="qt-everywhere-opensource-src-5.7.1"
SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}
SOURCE_URL="https://mirrors.tuna.tsinghua.edu.cn/qt/archive/qt/5.7/5.7.1/single/qt-everywhere-opensource-src-5.7.1.tar.xz"
SOURCE_SHA256SUM="46ebca977deb629c5e69c2545bc5fe13f7e40012e5e2e451695c583bd33502fa"

if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
      #  rm $SOURCE_PACKAGE  2> /dev/null
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


source ../common/common.sh

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}

pushd ${SOURCE_DIR}
if [ ! -d qtbase/mkspecs/${CROSS_COMPILER}-g++ ];then
    cp  qtbase/mkspecs/linux-arm-gnueabi-g++/ qtbase/mkspecs/${CROSS_COMPILER}-g++/ -r
    sed -i "s/arm-linux-gnueabi/${CROSS_COMPILER}/g" qtbase/mkspecs/${CROSS_COMPILER}-g++/qmake.conf
fi
./configure -extprefix ${SOURCE_DIR}/install -prefix / -release -opensource -confirm-license -no-pkg-config -qt-libjpeg -no-opengl -qt-zlib -no-icu  -xplatform ${CROSS_COMPILER}-g++ -no-xcb -no-dbus -v

make -j && make install
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

popd
