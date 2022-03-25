
# BringAuto Package Tracker

BringAuto package tracker based on [BringAuto Packager] and [CMake-lib]

## Usage

```
# Add package - download, cache and populate
BA_PACKAGE_LIBRARY(nlohmann-json v3.10.5)
# Find package as described in the library manual 
FIND_PACKAGE(nlohmann_json 3.2.0 REQUIRED)
```

Full example: [example/]

## Requirements

- [CMake-lib] (with STORAGE component enabled)
- Package repository that is complain with [BringAuto Packager] package repository structure.


## FAQ

### Q: Package not found even if it exists in the remote repository

Make sure you choosed correct PLATFORM_STRING_MODE.

Some packages are not bound to the architecture or Linux distro.
This information must be passed down by the PLATFORM_STRING_MODE.



[BringAuto Packager]: https://github.com/bringauto/packager
[CMake-lib]: https://github.com/cmakelib/cmakelib
[example/]: example/