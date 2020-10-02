macro(ext_enable_ext_libs ext_lib_name)
    set(ext_libraries_path_candidate "${CMAKE_CURRENT_SOURCE_DIR}/..")
    get_filename_component(ext_libraries_path_candidate "${ext_libraries_path_candidate}" ABSOLUTE)
    get_filename_component(ext_libraries_path_candidate_rel "${ext_libraries_path_candidate}" ABSOLUTE)

    if(NOT TARGET ext::${ext_lib_name})
        set(${ext_lib_name}_dir "${EXT_LIBRARIES_PATH}/${ext_lib_name}")
        ext_log("Searching for ${ext_lib_name} in ${ext_libraries_path_candidate_rel}/${ext_lib_name}")

        if(EXISTS ${${ext_lib_name}_dir}/include/ext)
            message(STATUS "extINFO -- found ${ext_lib_name} lib in ${${ext_lib_name}_dir}")
            add_subdirectory(${${ext_lib_name}_dir} "${CMAKE_BINARY_DIR}/${ext_lib_name}-build" EXCLUDE_FROM_ALL)
            if(NOT TARGET ext::${ext_lib_name})
                message(FATAL_ERROR "Adding ${ext_lib_name} lib as add_subdirectory failed.")
            endif()

            if(NOT EXT_LIBRARIES_PATH)
                message(INFO "extINFO -- Setting EXT_LIBRARIES_PATH to: ${ext_libraries_path_candidate} (cmake_enable_libs)")
                set(EXT_LIBRARIES_PATH "${ext_libraries_path_candidate}" CACHE PATH "Path of ext libraries.")
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

endmacro(ext_enable_ext_libs)
