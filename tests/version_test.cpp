#include <gtest/gtest.h>

#include "app/version.hpp"

// Placeholder to check that the test build works. Remove once real tests exist.
TEST(Version, NotEmpty) {
    EXPECT_FALSE(netwatch::app::version().empty());
}
