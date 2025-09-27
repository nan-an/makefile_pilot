# A Pilot C project using "Makefile"
## **Can be used as a template for new C projects.**

## Expected capabilities
- Build C projects using just `Makefile`, no `CMake` or `Meson`.
- Keep source files organized in `src` folder.
- Keep header files organized in `include` folder.
- Keep compiled object files and executables and libraries in `dist` folder.
- Basic support for unit tests using a single `litmus/tests.h` header.
- Test binaries are statically linked, with provision for `valgrind` based memory profiling.
- `TODO` [find alternatives] `Omarchy` does not seem to have debug info based `glibc` so `valgrind` is failing.
- On Mac `Leaks` is used for memory profiling.
- `TODO` Support for multiple build configurations (e.g., Debug, Release).
- `TODO` Support for unit testing frameworks (e.g., Google Test/CTest, currently uses bare bones litmus).
