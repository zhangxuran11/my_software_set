#!/bin/bash
if [ "x$ROOTFS" == "x" ];then
    export ROOTFS=${TOP_DIRECTOR}/build/out/rootfs
fi
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
        pushd libwebsockets
        ./build.sh clean
        popd
        pushd qt
        ./build.sh clean
        popd
        pushd jsoncpp
        ./build.sh clean
        popd

        ;;
    install)          
        pushd boost
        #./build.sh install
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
        pushd libwebsockets
        ./build.sh install
        popd
        pushd qt
        ./build.sh install
        popd
        pushd jsoncpp
        ./build.sh install
        popd
	
	rm ${ROOTFS}/include/* -rf 2> /dev/null
	rm ${ROOTFS}/lib/*.a
	rm ${ROOTFS}/lib/*.la
	rm ${ROOTFS}/lib/*.prl
	rm ${ROOTFS}/lib/cmake -r
	#rm ${TOP_DIRECTOR}/build/out/rootfs/lib/engines -r
	rm ${ROOTFS}/lib/pkgconfig -r
        
	;;
    *)
        echo './build.sh clean|install'
  esac
  exit 0

fi
pushd boost
#./build.sh
popd
pushd zlib
./build.sh
./build.sh install
popd
pushd openssl
./build.sh
./build.sh install
popd
pushd openssh
./build.sh
popd
pushd libwebsockets
./build.sh 
./build.sh install

popd
pushd qt
./build.sh
./build.sh install
popd
pushd jsoncpp
./build.sh
./build.sh install
popd
