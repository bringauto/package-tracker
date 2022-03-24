#
# BringAuto BA_PACKAGE example.
#
#

PROJECT(BA_PACKAGE_EXAMPLE CXX)
CMAKE_MINIMUM_REQUIRED(VERSION 3.18)

#
# We initialize CMLIB library.
# If you do not have one just follow https://github.com/cmakelib/cmakelib
#
FIND_PACKAGE(CMLIB
    COMPONENTS STORAGE
    REQUIRED
)

#
# Add package by a name specified in the registry:
#   https://gitlab.bringauto.com/bringauto-public/fleet-package-repository
#
BA_PACKAGE_LIBRARY(nlohmann-json v3.10.5 PLATFORM_STRING_MODE any_machine)

#
# After package add we can use standard FIND_LIBRARY
# as a documented by the package upstream
#
FIND_PACKAGE(nlohmann_json REQUIRED)

ADD_EXECUTABLE(json_test main.cpp)
TARGET_LINK_LIBRARIES(json_test PUBLIC nlohmann_json::nlohmann_json)