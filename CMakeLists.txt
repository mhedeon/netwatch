cmake_minimum_required(VERSION 3.30)

project(netwatch
    VERSION 0.1.0
    DESCRIPTION "Home network quality monitor"
    LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type" FORCE)
endif()

# Without a sysroot the cross toolchain links against a newer glibc than the Pi has,
# so until we have one, build a fully static binary.
if(CMAKE_CROSSCOMPILING AND NOT CMAKE_SYSROOT)
    set(_netwatch_static_default ON)
else()
    set(_netwatch_static_default OFF)
endif()

option(NETWATCH_BUILD_TESTS "Build unit tests" ${PROJECT_IS_TOP_LEVEL})
option(NETWATCH_WERROR "Treat warnings as errors" OFF)
option(NETWATCH_FULLY_STATIC "Link netwatchd with -static" ${_netwatch_static_default})

if(CMAKE_CROSSCOMPILING)
    set(NETWATCH_BUILD_TESTS OFF CACHE BOOL "Build unit tests" FORCE)
endif()

include(cmake/Dependencies.cmake)
include(cmake/Warnings.cmake)

# --- version --------------------------------------------------------------
find_package(Git QUIET)
set(NETWATCH_GIT_DESCRIBE "unknown")
if(GIT_FOUND)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} describe --always --dirty
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        OUTPUT_VARIABLE NETWATCH_GIT_DESCRIBE
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET)
endif()
configure_file(src/app/build_info.hpp.in ${PROJECT_BINARY_DIR}/generated/netwatch/build_info.hpp @ONLY)

# --- library with everything except main ---------------------------------
add_library(netwatch_core STATIC
    src/app/version.cpp
)
target_include_directories(netwatch_core
    PUBLIC
        ${PROJECT_SOURCE_DIR}/src
        ${PROJECT_BINARY_DIR}/generated)
target_link_libraries(netwatch_core
    PUBLIC
        asio::asio
        spdlog::spdlog
        tomlplusplus::tomlplusplus)
netwatch_set_warnings(netwatch_core)

# --- daemon ---------------------------------------------------------------
add_executable(netwatchd src/main.cpp)
target_link_libraries(netwatchd PRIVATE netwatch_core)
netwatch_set_warnings(netwatchd)
if(NETWATCH_FULLY_STATIC)
    target_link_options(netwatchd PRIVATE -static)
endif()

install(TARGETS netwatchd RUNTIME DESTINATION bin)

# --- tests ----------------------------------------------------------------
if(NETWATCH_BUILD_TESTS)
    enable_testing()
    add_subdirectory(tests)
endif()
