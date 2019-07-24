#!/bin/sh

CROSS_COMPILER=arm-hisiv500-linux-


file=boost_1_70_0.tar.bz2
file_md5=242ecc63507711d6706b9b0c0d0c7d4f

if [ $# == 1 ];then
	if [ $1 == 'clean' ];then
        rm boost_1_70_0 -rf       
        exit 0
	fi
fi

if [ -f "$file" ]; then
    md5=`md5sum  $file| awk '{ print $1 }'`
    if [ $md5 != $file_md5 ]; then
        wget https://dl.bintray.com/boostorg/release/1.70.0/source/$file
    fi
else
    wget https://dl.bintray.com/boostorg/release/1.70.0/source/$file
fi
if [ ! -d "boost_1_70_0" ];then
    tar -xvf $file
fi

pushd boost_1_70_0
./bootstrap.sh --prefix=./install
if [ "x${CROSS_COMPILER}" != "x" ];then
    echo ${CROSS_COMPILER}
    sed  -i "s/using gcc ;/using gcc : arm  : ${CROSS_COMPILER}g++ ;/g" project-config.jam
fi
./bjam --with-libraries=system,thread --without-libraries=python
./b2
./b2 install --prefix=./install
popd
