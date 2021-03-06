#!/bin/bash

if [ "x"${CROSS_COMPILER} == "x" ];then
    CROSS_COMPILER=arm-hisiv500-linux
fi


#SOURCE_DIR="boost_1_70_0"
#SOURCE_PACKAGE="boost_1_70_0.tar.bz2"
#SOURCE_URL="https://dl.bintray.com/boostorg/release/1.70.0/source/${SOURCE_PACKAGE}"
#SOURCE_SHA256SUM="430ae8354789de4fd19ee52f3b1f739e1fba576f0aded0897c3c2bc00fb38778"    #for 1.70.0


SOURCE_DIR="boost_1_65_1"
SOURCE_PACKAGE="boost_1_65_1.tar.bz2"
SOURCE_URL="https://dl.bintray.com/boostorg/release/1.65.1/source/${SOURCE_PACKAGE}"
SOURCE_SHA256SUM="9807a5d16566c57fd74fb522764e0b134a8bbe6b6e8967b83afefd30dcd3be81"    #for 1.65.1

#SOURCE_PACKAGE="boost_1_46_1.bz2"
#SOURCE_URL="https://jaist.dl.sourceforge.net/project/boost/boost/1.46.1/${SOURCE_PACKAGE}"
#SOURCE_SHA256SUM="e1dfbf42b16e5015c46b98e9899c423ca4d04469cbeee05e43ea19236416d883"    #for 1.46.1
#SOURCE_DIR="boost_1_46_1"

SOURCE_PACKAGE_FULL_PATH=$(pwd)/${SOURCE_PACKAGE}
SOURCE_DIR_FULL_PATH=$(pwd)/${SOURCE_DIR}

source ../common/common.sh

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
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi

check_and_get_source_package ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_URL} ${SOURCE_SHA256SUM}
check_and_unpackage_source ${SOURCE_PACKAGE_FULL_PATH} ${SOURCE_DIR_FULL_PATH}


pushd ${SOURCE_DIR_FULL_PATH}

./bootstrap.sh --prefix=./install --without-libraries=python
if [ "x${CROSS_COMPILER}" != "x" ];then
    echo ${CROSS_COMPILER}
    sed  -i "s/using gcc ;/using gcc : 4.9.4  : ${CROSS_COMPILER}-g++ ;/g" project-config.jam
fi
#./bjam --with-system --with-thread --without-python #for 1.70.0
#./bjam --with-thread
#./bjam   #for 1.46.1
#./bjam install --prefix=./install #for 1.70.0
./b2   #for 1.70.0
./b2 install --prefix=./install #for 1.70.0
if [ $? != 0 ];then
    echo "编译出错，异常退出..."
    exit -1
fi

popd
