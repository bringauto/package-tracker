SET(PROJECT_NAME    shared_out_of_dir_symlink)
SET(PROJECT_VERSION 0.2.6)

PROJECT(${PROJECT_NAME} C)
CMAKE_MINIMUM_REQUIRED(VERSION 3.21)

SET(CMAKE_BUILD_TYPE Release)

FIND_PACKAGE(CMLIB COMPONENTS CMDEF REQUIRED)




SET(install_dir  "lib/${PROJECT_NAME}")
SET(library_name "${PROJECT_NAME}")
SET(version      "${PROJECT_VERSION}")


CMDEF_ADD_LIBRARY(
    LIBRARY_GROUP ${PROJECT_NAME}
    TYPE          SHARED
    SOURCES       library.c
    VERSION       ${PROJECT_VERSION}
)

SET_TARGET_PROPERTIES(${PROJECT_NAME}-shared
    PROPERTIES
        SOVERSION ${PROJECT_VERSION}
        VERSION   ${PROJECT_VERSION}
)

SET(old_install_dir ${CMDEF_LIBRARY_INSTALL_DIR})
SET(CMDEF_LIBRARY_INSTALL_DIR "${install_dir}"
    CACHE STRING "Overriden"
    FORCE
)
CMDEF_INSTALL(TARGET ${PROJECT_NAME}-shared)
SET(CMDEF_LIBRARY_INSTALL_DIR "${old_install_dir}"
    CACHE STRING "Overriden"
    FORCE
)

# Create a package
CMDEF_PACKAGE(
    MAIN_TARGET ${PROJECT_NAME}-shared
    VERSION     ${PROJECT_VERSION}
)

SET(library_soname lib${library_name}.so.${version})
SET(link_soname    lib${library_name}.so)
INSTALL(CODE "SET(CMAKE_INSTALL_PREFIX ${CMAKE_INSTALL_PREFIX})")
INSTALL(CODE "SET(CMDEF_LIBRARY_INSTALL_DIR ${CMDEF_LIBRARY_INSTALL_DIR})")
INSTALL(CODE "SET(install_dir      ${install_dir})")
INSTALL(CODE "SET(link_soname      ${link_soname})")
INSTALL(CODE "SET(library_soname   ${library_soname})")
INSTALL(CODE "SET(link_filepath    ${install_dir}/${link_soname})")
INSTALL(CODE "SET(library_filepath ${install_dir}/${library_soname})")
INSTALL(CODE "SET(new_library_filepath ${CMDEF_LIBRARY_INSTALL_DIR}/${library_soname})")
INSTALL(CODE [[
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E copy "${library_filepath}" "${new_library_filepath}"
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E rm "${library_filepath}"
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E rm "${link_filepath}"
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E create_symlink "${new_library_filepath}" ${link_filepath}
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E create_symlink "${new_library_filepath}" ${library_filepath}
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    FILE(RELATIVE_PATH "${new_library_filepath}" ${CMAKE_CURRENT_LIST_DIR} "${library_filepath}")
    MESSAGE(STATUS "-=-=-=-> ${ttt}")
]])

SET(CPACK_GENERATOR ZIP)
INCLUDE(CPack)