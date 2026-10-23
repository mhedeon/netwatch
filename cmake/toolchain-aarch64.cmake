# Cross build for Raspberry Pi 3B+ (Cortex-A53, aarch64).
#
#   cmake --preset aarch64-release
#   cmake --preset aarch64-release -DNETWATCH_SYSROOT=$HOME/pi-sysroot
#
# The sysroot can also be set via the NETWATCH_SYSROOT environment variable.

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR aarch64)

set(_triple aarch64-linux-gnu)
set(CMAKE_C_COMPILER   ${_triple}-gcc)
set(CMAKE_CXX_COMPILER ${_triple}-g++)

if(NOT NETWATCH_SYSROOT AND DEFINED ENV{NETWATCH_SYSROOT})
    set(NETWATCH_SYSROOT "$ENV{NETWATCH_SYSROOT}")
endif()
# The toolchain file is re-read inside try_compile; without this the variable is lost there.
list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES NETWATCH_SYSROOT)

if(NETWATCH_SYSROOT)
    set(CMAKE_SYSROOT "${NETWATCH_SYSROOT}")
    set(CMAKE_FIND_ROOT_PATH "${NETWATCH_SYSROOT}")
endif()

# Never pick up host libraries or headers; programs come from the host only.
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_C_FLAGS_INIT   "-mcpu=cortex-a53")
set(CMAKE_CXX_FLAGS_INIT "-mcpu=cortex-a53")

# GCC 15 on the PC is newer than on the Pi: link libstdc++ and libgcc statically.
set(CMAKE_EXE_LINKER_FLAGS_INIT "-static-libstdc++ -static-libgcc")
