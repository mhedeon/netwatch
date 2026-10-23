# All external dependencies. Tags are pinned; bump them deliberately.
include(FetchContent)

set(FETCHCONTENT_QUIET OFF)

# Standalone Asio ships no CMakeLists, so we define the INTERFACE target ourselves.
FetchContent_Declare(asio
    GIT_REPOSITORY https://github.com/chriskohlhoff/asio.git
    GIT_TAG        asio-1-38-2
    GIT_SHALLOW    ON)

set(SPDLOG_USE_STD_FORMAT ON CACHE BOOL "" FORCE)
set(SPDLOG_BUILD_EXAMPLE OFF CACHE BOOL "" FORCE)
FetchContent_Declare(spdlog
    GIT_REPOSITORY https://github.com/gabime/spdlog.git
    GIT_TAG        v1.17.0
    GIT_SHALLOW    ON)

FetchContent_Declare(tomlplusplus
    GIT_REPOSITORY https://github.com/marzer/tomlplusplus.git
    GIT_TAG        v3.4.0
    GIT_SHALLOW    ON)

FetchContent_MakeAvailable(asio spdlog tomlplusplus)

if(NOT TARGET asio::asio)
    find_package(Threads REQUIRED)
    add_library(asio INTERFACE)
    add_library(asio::asio ALIAS asio)
    # SYSTEM: we don't care about warnings from third-party headers
    target_include_directories(asio SYSTEM INTERFACE ${asio_SOURCE_DIR}/asio/include)
    target_compile_definitions(asio INTERFACE ASIO_STANDALONE ASIO_NO_DEPRECATED)
    target_link_libraries(asio INTERFACE Threads::Threads)
endif()

if(NETWATCH_BUILD_TESTS)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    set(BUILD_GMOCK ON CACHE BOOL "" FORCE)
    FetchContent_Declare(googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG        v1.17.0
        GIT_SHALLOW    ON)
    FetchContent_MakeAvailable(googletest)
endif()
