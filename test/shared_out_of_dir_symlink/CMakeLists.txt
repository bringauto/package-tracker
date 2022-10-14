SET(PROJECT_NAME    shared_out_of_dir_symlink)
SET(PROJECT_VERSION 0.2.6)

PROJECT(${PROJECT_NAME} CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 3.21)

FIND_PACKAGE(CMDEF REQUIRED)




SET(install_dir  "${CMDEF_LIBRARY_INSTALL_DIR}${PROJECT_NAME}")
SET(library_name "${PROJECT_NAME}")
SET(version      "${PROJECT_VERSION}")

ADD_LIBRARY(${PROJECT_NAME} SHARED library.c)

SET_TARGET_PROPERTIES(${PROJECT_NAME}
    PROPERTIES
        SOVERSION ${PROJECT_VERSION}
        VERSION   ${PROJECT_VERSION}
)

INSTALL(TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION "${install_dir}"
)

SET(library_soname lib${library_name}.so)
SET(link_soname    lib${library_name}.so.${version})
INSTALL(CODE "SET(filepath ${install_dir}/${library_soname})")
INSTALL(CODE [[
    EXECUTE_PROCESS(
        COMMAND ${CMAKE_COMMAND} -E create_symlink ${filepath} ${CMDEF_LIBRARY_INSTALL_DIR}/${link_soname}
        RESULT_VARIABLE    result
        WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/"
    )
    IF(NOT result EQUAL 0)
        MESSAGE(FATAL_ERROR "Cannot cannot create symlink ")
    ENDIF()
]])