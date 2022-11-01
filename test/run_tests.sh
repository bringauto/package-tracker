#!/bin/sh

set -e

cmake -DTEST_WITH_DESTDIR=OFF -P ./run_tests.cmake
cmake -DTEST_WITH_DESTDIR=ON  -P ./run_tests.cmake