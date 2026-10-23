include(GoogleTest)

add_executable(netwatch_tests
    version_test.cpp
)
target_link_libraries(netwatch_tests PRIVATE netwatch_core GTest::gtest_main)
netwatch_set_warnings(netwatch_tests)
# Repo root for tests that read files from deploy/ and fixtures.
target_compile_definitions(netwatch_tests PRIVATE NETWATCH_SOURCE_DIR="${PROJECT_SOURCE_DIR}")

gtest_discover_tests(netwatch_tests)
