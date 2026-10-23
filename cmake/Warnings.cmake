# Warnings for our own targets only; dependencies are left alone.
function(netwatch_set_warnings target)
    target_compile_options(${target} PRIVATE
        -Wall -Wextra -Wpedantic
        -Wconversion -Wsign-conversion -Wshadow
        -Wnon-virtual-dtor -Wold-style-cast -Woverloaded-virtual
        -Wdouble-promotion -Wformat=2)
    if(NETWATCH_WERROR)
        target_compile_options(${target} PRIVATE -Werror)
    endif()
endfunction()
