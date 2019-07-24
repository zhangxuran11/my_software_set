SET(CROSS_COMPILE 1)
option (BUILD_TESTS "Build websocketpp tests." TRUE)
set (CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_SOURCE_DIR}/install" CACHE PATH "")
IF(CROSS_COMPILE) 
  
SET(CMAKE_SYSTEM_NAME Linux)
SET(TOOLCHAIN_DIR "/opt/hisi-linux/x86-arm/arm-hisiv600-linux")

set(CMAKE_CXX_COMPILER arm-hisiv600-linux-g++)
set(CMAKE_C_COMPILER   arm-hisiv600-linux-gcc)
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
 ${TOOLCHAIN_DIR}/arm-hisiv600-linux-gnueabi/lib )

include_directories(${TOOLCHAIN_DIR}/arm-hisiv600-linux-gnueabi/include/c++/)

#link_directories(/home/zchx/Downloads/boost_1_49_0_arm/stage/lib)
  
ENDIF(CROSS_COMPILE)
