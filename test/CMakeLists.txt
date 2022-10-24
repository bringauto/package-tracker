
CMAKE_MINIMUM_REQUIRED(VERSION 3.21)

IF(NOT CMAKE_SCRIPT_MODE_FILE)
    MESSAGE(FATAL_ERROR "Please, run list in CMake script mode!")
ENDIF()

SET(TEST_BASE_PATH "${CMAKE_CURRENT_LIST_DIR}/app/tests_list")

FUNCTION(RUN_AND_EVALUATE_TEST testbase_path testfile_name)
    EXECUTE_PROCESS(
        COMMAND           "git" "clean" "-xfd" "."
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        RESULT_VARIABLE   git_clean_result
    )
    IF(NOT git_clean_result EQUAL 0)
        MESSAGE(FATAL_ERROR "Cannot clean up test directory!")
    ENDIF()
    SET(testapp_install_dir "${CMAKE_CURRENT_LIST_DIR}/TestAppInstallDir")
    EXECUTE_PROCESS(
        COMMAND "${CMAKE_COMMAND}" "-DBA_PACKAGE_TEST_NAME=${testfile_name}"
            -DCMAKE_BUILD_TYPE=Release
            -DCMAKE_INSTALL_PREFIX="${testapp_install_dir}"
            "app/"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        RESULT_VARIABLE   test_result
    )
    IF(NOT test_result EQUAL 0)
        MESSAGE(FATAL_ERROR "test '${testfile_name}' failed!")
    ENDIF()
    INCLUDE("${testbase_path}/${testfile_name}")
    IF(NOT COMMAND TEST_GET_EXPECTED_INSTALLED_FILES_LIST)
        MESSAGE(FATAL_ERROR "In the test ${testfile_name} the function TEST_GET_EXPECTED_INSTALLED_FILES_LIST is not found!")
    ENDIF()
    TEST_GET_EXPECTED_INSTALLED_FILES_LIST(expected_testapp_installed_file_list)
    FOREACH(expected_file_path IN LISTS expected_testapp_installed_file_list)
        IF(NOT EXISTS "${testapp_install_dir}/${expected_file_path}")
            MESSAGE(FATAL_ERROR "Error: expected file '${expected_file_path}' is not in the testapp install directory")
        ENDIF()
    ENDFOREACH()
ENDFUNCTION()



FILE(GLOB tests_name_list RELATIVE "${TEST_BASE_PATH}" "${TEST_BASE_PATH}/*")
FOREACH(testfile_name IN LISTS tests_name_list)
    RUN_AND_EVALUATE_TEST("${TEST_BASE_PATH}" ${testfile_name}) 
ENDFOREACH()