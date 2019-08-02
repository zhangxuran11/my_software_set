SET(CROSS_COMPILE 0)
option (BUILD_EXAMPLES "Build websocketpp examples." TRUE)
option (BUILD_TESTS "Build websocketpp tests." TRUE)
set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/install" CACHE PATH "")
IF(CROSS_COMPILE) 
SET(CMAKE_SYSTEM_NAME Linux)

SET(TOOLCHAIN_DIR "/opt/hisi-linux/x86-arm/arm-hisiv500-linux")

#SET(OPENSSL_ROOT_DIR "${TOOLCHAIN_DIR}/target/")
SET(OPENSSL_INCLUDE_DIR "${TOOLCHAIN_DIR}/target/include/openssl/")
SET(OPENSSL_CRYPTO_LIBRARY "${TOOLCHAIN_DIR}/target/lib")
SET(OPENSSL_SSL_LIBRARY "${TOOLCHAIN_DIR}/target/lib/")
#SET(OPENSSL_VERSION "1.0.2sss")
SET(ZLIB_LIBRARY "${TOOLCHAIN_DIR}/target/lib")
SET(ZLIB_INCLUDE_DIR "${TOOLCHAIN_DIR}/target/include")


set(CMAKE_CXX_COMPILER arm-hisiv500-linux-g++)
set(CMAKE_C_COMPILER   arm-hisiv500-linux-gcc)
set(GNU_FLAGS "-mfpu=vfp -fPIC")
set(CMAKE_CXX_FLAGS "${GNU_FLAGS} ")
set(CMAKE_C_FLAGS "${GNU_FLAGS}  ")
#从来不在指定目录下查找工具程序
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
#只在指定目录下查找库文件
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
#只在指定目录下查找头文件
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

SET(CMAKE_FIND_ROOT_PATH  
 ${TOOLCHAIN_DIR}/arm-hisiv500-linux-gnueabi/lib )

include_directories(${TOOLCHAIN_DIR}/arm-hisiv500-linux-gnueabi/include/c++/)

  
ENDIF(CROSS_COMPILE)
