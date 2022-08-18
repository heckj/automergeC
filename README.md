# Swift package wrapping Automerge's FFI C-based interface




## Building the C interface (macOS)

    brew install cmake
    brew install cmocka

    # adjustments to get cmocka available to automerge's CMake setup
    export CPATH=/opt/homebrew/include
    export LIBRARY_PATH=/opt/homebrew/lib
    # export CMAKE_PREFIX_PATH=/opt/homebrew

    git clone https://github.com/automerge/automerge-rs.git
    cd automerge-rs/automerge-c
    rm -rf build
    mkdir -p build
    cd build
    cmake -S .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
    cmake --build . --target test_automerge

C target results at:

```bash
automerge-rs/automerge-c/build/Cargo/target/release/libautomerge.a
automerge-rs/automerge-c/build/Cargo/target/automerge.h
```
