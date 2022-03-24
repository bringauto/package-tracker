
# BringAuto Package Tracker

BringAuto package tracker based on [BringAuto Packager] and [CMake-lib]

## Usage

```
# Add package - download, cache and populate
BA_PACKAGE_LIBRARY(nlohmann-json v3.10.5)
FIND_PACKAGE(nlohmann_json 3.2.0 REQUIRED)
```

Full example: [example/]

## Requirements

- [CMake-lib] (with STORAGE component enabled)
- Package repository that is complain with [BringAuto Packager] package repository structure.



[BringAuto Packager]: ./
[CMake-lib]: https://github.com/cmakelib/cmakelib
[example/]: example/