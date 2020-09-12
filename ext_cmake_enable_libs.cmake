macro(ext_enable_ext_libs ext_lib_name)
    set(EXT_LIBRARIES_PATH "${CMAKE_CURRENT_SOURCE_DIR}/..")
    ##### find ${ext_lib_name} lib #########################################################
    if(NOT TARGET ext::${ext_lib_name})
        set(${ext_lib_name}_dir "${EXT_LIBRARIES_PATH}/${ext_lib_name}")
        ext_log("Searching for ${exit_lib_name} in ${EXT_LIBRARIES_PATH}/${ext_lib_name}")
        if(EXISTS ${${ext_lib_name}_dir}/include/ext/config.hpp)
            message(STATUS "extINFO -- found ${ext_lib_name} lib in ${${ext_lib_name}_dir}")
            add_subdirectory(${${ext_lib_name}_dir} ${${ext_lib_name}_dir}-build EXCLUDE_FROM_ALL)
            if(NOT TARGET ext::${ext_lib_name})
                message(FATAL_ERROR "Adding ${ext_lib_name} lib as add_subdirectory failed.")
            endif()
        else()
            message(STATUS "extINFO -- cloning ${ext_lib_name} from github")
            include(FetchContent)
            FetchContent_Declare(ext_${ext_lib_name}_github
                GIT_REPOSITORY https://github.com/extcpp/${ext_lib_name}.git
                GIT_TAG master
                GIT_PROGRESS TRUE
            )
            FetchContent_MakeAvailable(ext_${ext_lib_name}_github)
            set(${ext_lib_name}_dir "${ext_${ext_lib_name}_github_SOURCE_DIR}")
        endif()
    endif() # NOT TARGET ext::${ext_lib_name}

    if(NOT TARGET ext::${ext_lib_name})
        message(FATAL_ERROR "Could not make ext::${ext_lib_name} library available.")
    endif() # NOT TARGET ext::${ext_lib_name}
    ##### find ${ext_lib_name} lib #########################################################
endmacro(ext_enable_ext_libs)
