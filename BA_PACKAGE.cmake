
FIND_PACKAGE(CMLIB COMPONENTS CMUTIL CMDEF)



##
#
# Download, cache and populate library development package
#
# CACHE_ONLY - if specified no download is performed. The package
# must be cached by previous of BA_PACKAGE_LIBRARY() without CACHE_ONLY switch.
#
# PLATFORM_STRING_MODE - mode of platform string construction (platform string represents
# id of the target platfrom for which we build...).
#   - "aby_machine" - inform packager we use package that is not bound to the target architecture.
#
# <function>(
#   <package_name>
#   <version_tag>
#   [PLATFORM_STRING_MODE {"any_machine"}]
#   [CACHE_ONLY {ON|OFF}]
# )
#
FUNCTION(BA_PACKAGE_LIBRARY package_name version_tag)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            PLATFORM_STRING_MODE
        OPTIONS
            CACHE_ONLY
        P_ARGN
            ${ARGN}
    )

    SET(suffix)
    IF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        SET(suffix "d")
    ENDIF()

    _BRINGAUTO_PACKAGE(${package_name} ${version_tag} "lib" "${suffix}-dev" output_var
        PLATFORM_STRING_MODE ${__PLATFORM_STRING_MODE}
        CACHE_ONLY           ${__CACHE_ONLY}
    )

    SET(_t ${CMAKE_PREFIX_PATH})
    LIST(APPEND _t "${output_var}")
    SET(CMAKE_PREFIX_PATH ${_t} PARENT_SCOPE)

ENDFUNCTION()



##
#
# Download, cache and populate Executable package
#
# <function>(
#   <package_name>
#   <version_tag>
#   [PLATFORM_STRING_MODE {"any_machine"}]
#   [CACHE_ONLY {ON|OFF}]
# )
#
FUNCTION(BA_PACKAGE_EXECUTABLE package_name varsion_tag)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            PLATFORM_STRING_MODE
        OPTIONS
            CACHE_ONLY
        P_ARGN
            ${ARGN}
    )

    SET(suffix)
    IF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
        SET(suffix "d")
    ENDIF()

    _BRINGAUTO_PACKAGE(${package_name} ${version_tag} "" "${suffix}" output_var
        PLATFORM_STRING_MODE ${__PLATFORM_STRING_MODE}
        CACHE_ONLY           ${__CACHE_ONLY}
    )

    SET(_t ${CMAKE_PREFIX_PATH})
    LIST(APPEND _t "${output_var}")
    SET(CMAKE_PREFIX_PATH ${_t} PARENT_SCOPE)

ENDFUNCTION()



## Helper
#
# Download, cache and populate package represented by 'package_name'
# and concretized by 'prefix' and 'suffix'.
#
# <function>(
#   <package_name>
#   <version_tag>
#   [PLATFORM_STRING_MODE {"any_machine"}]
#   [CACHE_ONLY {ON|OFF}]
# )
#
FUNCTION(_BRINGAUTO_PACKAGE package_name version_tag prefix suffix output_var)
    CMLIB_PARSE_ARGUMENTS(
        ONE_VALUE
            PLATFORM_STRING_MODE
        OPTIONS
            CACHE_ONLY
        P_ARGN
            ${ARGN}
    )

    MESSAGE(STATUS "BA Package '${package_name}'")

    STRING(TOLOWER "${__PLATFORM_STRING_MODE}" plat_string_mode_lower)

    SET(machine)
    IF("${plat_string_mode_lower}" STREQUAL "any_machine")
        SET(machine "any")
    ELSE()
        SET(machine "${CMDEF_ARCHITECTURE}")
    ENDIF()

    SET(package_name_expanded "${prefix}${package_name}${suffix}")

    CMUTIL_PLATFORM_STRING_CONSTRUCT(
        MACHINE ${machine}
        DISTRO_NAME_ID "${CMDEF_DISTRO_ID}"
        DISTRO_VERSION_ID "${CMDEF_DISTRO_VERSION_ID}"
        OUTPUT_VAR platform_string
    )
    SET(package_string "${package_name_expanded}_${version_tag}_${platform_string}.zip")

    SET(git_path "${CMDEF_DISTRO_ID}/${CMDEF_DISTRO_VERSION_ID}/${machine}")
    CMLIB_STORAGE_TEMPLATE_INSTANCE( remote_file BRINGAUTO_REPOSITORY_URL_TEMPLATE
        REVISION "master"
        GIT_PATH "${git_path}"
        PACKAGE_NAME "${package_string}"
        ARCHIVE_NAME "${package_name}"
    )

    STRING(TOUPPER "${package_name}" package_name_upper)
    STRING(REGEX REPLACE "[^A-Z]" "" package_name_upper  "${package_name_upper}")
    IF(NOT package_name_upper)
        MESSAGE(FATAL_ERROR "Invalid package name: ${package_name}")
    ENDIF()
    SET(keywords BAPACK ${package_name_upper})

    SET(cache_path)
    IF(__CACHE_ONLY)
        CMLIB_CACHE_GET(
            KEYWORDS ${keywords}
            CACHE_PATH_VAR cache_path
            TRY_REGENERATE ON
        )
        IF(NOT cache_path)
            MESSAGE(FATAL_ERROR "Package does not found: ${package_string}")
        ENDIF()
    ELSE()
        CMLIB_DEPENDENCY(
            KEYWORDS ${keywords}
            TYPE ARCHIVE
            URI "${remote_file}"
            OUTPUT_PATH_VAR cache_path
        )
    ENDIF()

    SET(${output_var} ${cache_path} PARENT_SCOPE)
ENDFUNCTION()
