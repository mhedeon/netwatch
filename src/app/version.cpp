#include "app/version.hpp"

#include <netwatch/build_info.hpp>

namespace netwatch::app {

std::string_view version() noexcept {
    return NETWATCH_VERSION " (" NETWATCH_GIT_DESCRIBE ")";
}

} // namespace netwatch::app
