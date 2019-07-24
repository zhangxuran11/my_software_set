#!/bin/sh
git clone  --branch 0.8.1 https://github.com/zaphoyd/websocketpp.git  websocketpp-0.8.1
mkdir websocketpp-0.8.1/build
cp cross.cmake websocketpp-0.8.1/build
sed -i '8i\include(${CMAKE_CURRENT_SOURCE_DIR}/build/cross.cmake)' websocketpp-0.8.1/CMakeLists.txt
pushd websocketpp-0.8.1/build
cmake ..
make
make install
popd
