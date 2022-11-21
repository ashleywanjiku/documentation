# @brief Set variable indicating if this is a master project
# - This is important to avoid building tests and examples when project is not master
macro(set_master_project_booleans)
    if (${PROJECT_SOURCE_DIR} STREQUAL ${CMAKE_SOURCE_DIR})
        set(MASTER_PROJECT ON)
    else ()
        set(MASTER_PROJECT OFF)
    endif ()
endmacro()

# @brief Set variable indicating if this is a master project
# - This is important to avoid building tests and examples when project is not master
macro(set_crosscompiling_booleans)
    if (CMAKE_CROSSCOMPILING)
        set(DOXYBOOK_CROSSCOMPILING ON)
        set(DOXYBOOK_NOT_CROSSCOMPILING OFF)
    else ()
        set(DOXYBOOK_CROSSCOMPILING OFF)
        set(DOXYBOOK_NOT_CROSSCOMPILING ON)
    endif ()
endmacro()

# @brief Set variables indicating if mode is Debug or Release
# - The mode might be neither of them
macro(set_debug_booleans)
    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(DEBUG_MODE ON)
        set(NOT_DEBUG_MODE OFF)
        set(RELEASE_MODE OFF)
        set(NOT_RELEASE_MODE ON)
    else ()
        set(DEBUG_MODE OFF)
        set(NOT_DEBUG_MODE ON)
        set(RELEASE_MODE ON)
        set(NOT_RELEASE_MODE OFF)
    endif ()
endmacro()

# @brief Create booleans GCC and CLANG to identify the compiler more easily
# - A boolean for MSVC already exists by default
macro(set_compiler_booleans)
    set(CLANG OFF)
    set(GCC OFF)
    if (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
        set(CLANG ON)
    elseif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        set(GCC ON)
    endif ()

    # Check if we are using the "expected" compilers, which are usually
    # Win+MSVC, Linux+GCC, Mac+Clang
    set(EXPECTED_COMPILER OFF)
    if (WIN32 AND MSVC)
        set(EXPECTED_COMPILER ON)
    elseif (APPLE AND CLANG)
        set(EXPECTED_COMPILER ON)
    elseif (UNIX AND NOT APPLE AND GCC)
        set(EXPECTED_COMPILER ON)
    endif ()
endmacro()

# @brief Set the default optimization flags in case the user didn't
#        explicitly choose it with -DCMAKE_CXX_FLAGS
macro(set_optimization_flags)
    set(OPTIMIZATION_FLAG_IS_SET OFF)
    if (CMAKE_CXX_FLAGS)
        set(COMMON_OPT_FLAGS
                /O1 /O2 /Ob /Od /Og /Oi /Os /Ot /Ox /Oy /favor
                -O0 -O1 -O -O2 -O3 -Os -Ofast -Og)
        string(REPLACE " " ";" CMAKE_CXX_FLAGS_LIST ${CMAKE_CXX_FLAGS})
        foreach (FLAG ${CMAKE_CXX_FLAGS_LIST})
            if (${FLAG} IN_LIST COMMON_OPT_FLAGS)
                message("CXX optimization flag is already set to ${FLAG}")
                set(OPTIMIZATION_FLAG_IS_SET ON)
            endif ()
        endforeach ()
    endif ()

    if (NOT OPTIMIZATION_FLAG_IS_SET)
        if (CMAKE_BUILD_TYPE STREQUAL "Debug")
            if (EMSCRIPTEN)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0 -g4")
            elseif (MSVC)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /Od")
            elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "AppleClang")
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
            else ()
                # https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
            endif ()
        else ()
            if (MSVC)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /O2")
            else ()
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O2")
            endif ()
        endif ()
        message("Setting CXX flags to default for ${CMAKE_BUILD_TYPE} mode (${CMAKE_CXX_FLAGS})")
    endif ()
endmacro()