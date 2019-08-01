#!/bin/bash
if [ "x"$1 != "x" ];then
  case $1 in    
    clean)
        pushd boost
        ./build.sh clean
        popd
        pushd zlib
        ./build.sh clean
        popd
        pushd openssl
        ./build.sh clean
        popd
        pushd openssh
        ./build.sh clean
        popd

        ;;
    install)          
        pushd boost
        ./build.sh install
        popd
        pushd zlib
        ./build.sh install
        popd
        pushd openssl
        ./build.sh install
        popd
        pushd openssh
        ./build.sh install
        popd
        ;;
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi
pushd boost
./build.sh
popd
pushd zlib
./build.sh
popd
pushd openssl
./build.sh
popd
pushd openssh
./build.sh
popd
