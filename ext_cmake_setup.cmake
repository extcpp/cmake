# TODO - test this macro in other libs
# execute macro only in top-level CMakeLists.txt
if(EXT_SETUP_DONE)
    return()
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL
    "Export compile_comands.json to be consumed by clang-completion")
set(CMAKE_CXX_STANDARD 17 CACHE STRING "Use C++17 standard.")
set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE BOOL "Use plain C++ (no GNU extentions)")
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # XCode / VS folders

include(ext_cmake_utils)
include(ext_cmake_install)
include(ext_cmake_compiler_specific)
include(ext_cmake_enable_libs)

ext_define_warning_flags()
ext_colored_compiler_ouput(ON)

include (TestBigEndian)
TEST_BIG_ENDIAN(ext_is_big_endian)

# execute this setup just once
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux")
    set(LINUX TRUE)
else()
    set(LINUX FALSE)
endif()

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
# set / modify default install prefix
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    ext_log("install location defaulted")
    if(UNIX)
        ##set(CMAKE_INSTALL_PREFIX  "$ENV{HOME}/.local")
    else()
        # do not change the default for other operating systems
    endif()
else()
    ext_log("install location manually provided")
endif()
ext_log("installing to: ${CMAKE_INSTALL_PREFIX}")


set(EXT_CXX_COMPILER_IS_GCC FALSE)
set(EXT_CXX_COMPILER_IS_CLANG FALSE)
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(EXT_CXX_COMPILER_IS_GCC TRUE)
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(EXT_CXX_COMPILER_IS_CLANG TRUE)
endif()

set(EXT_SETUP_DONE TRUE)
