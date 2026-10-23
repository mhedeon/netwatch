// Temporary main to check the build: dependencies are found and linked.
// Replace with a call to app::run(args) per the stage 1 plan.
#include <asio/io_context.hpp>
#include <spdlog/spdlog.h>
#include <toml++/toml.hpp>

#include "app/version.hpp"

int main() {
    asio::io_context io;
    auto cfg = toml::parse("[daemon]\ntick_ms = 1000\n");
    spdlog::info("netwatchd {} tick_ms={}", netwatch::app::version(),
                 cfg["daemon"]["tick_ms"].value_or(0));
    io.run();
    return 0;
}
