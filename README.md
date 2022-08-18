# Swift package wrapping Automerge's FFI C-based interface

Much of the setup here is inspired by the blog post about building
C FFI interfaces from Rust and combining them to make them available
for Swift on various Apple platforms.

https://betterprogramming.pub/from-rust-to-swift-df9bde59b7cd

A concrete implementation is reflected in the earlier C API for Automerge,
roughly captured in https://github.com/automerge/automerge-swift-backend.
The build setup for Automerge has changed since that was set up, interposing
CMake, which in turn calls Cargo, for their V2 of the C API.


## Building the C interface (macOS)

    brew install cmake
    brew install cmocka

    # adjustments to get cmocka available to automerge's CMake setup
    export CPATH=/opt/homebrew/include
    export LIBRARY_PATH=/opt/homebrew/lib
    # export CMAKE_PREFIX_PATH=/opt/homebrew

    git clone https://github.com/automerge/automerge-rs.git
    mkdir -p automerge-rs/automerge-c/build
    pushd automerge-rs/automerge-c/build
    cmake -S .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF
    cmake --build . --target test_automerge
    popd

C target results at:

```bash
automerge-rs/automerge-c/build/Cargo/target/release/libautomerge.a
automerge-rs/automerge-c/build/Cargo/target/automerge.h
```

Architecture of the library:

    lipo -info automerge-rs/automerge-c/build/Cargo/target/release/libautomerge.a

`Non-fat file: automerge-rs/automerge-c/build/Cargo/target/release/libautomerge.a is architecture: arm64`

When we have a path to doing so, build the static library for the following architectures:
- `x86_64-apple-darwin` and `aarch64-apple-darwin` — macOS
- `x86_64-apple-ios` and `aarch64-apple-ios-sim` — iOS Simulator
- `x86_64-apple-ios-macabi` and `aarch64-apple-ios-macabi` — Mac Catalyst
And then use additional `lipo` commands (per blog post examples) to combine the resulting static libraries into a single fat file library.

Copy the header into the top level include directory so that swift can
use it:

    cp automerge-rs/automerge-c/build/Cargo/target/automerge.h include/

Generate an XCFramework:

    rm -rf xcframework
    mkdir -p xcframework

    xcodebuild -create-xcframework \
    -library automerge-rs/automerge-c/build/Cargo/target/release/libautomerge.a \
    -headers ./include/ \
    -output ./xcframework/automergeC.xcframework

    echo "▸ Compress automergeC.xcframework"
    ditto -c -k --sequesterRsrc --keepParent ./xcframework/automergeC.xcframework ./automergeC.xcframework.zip

    echo "▸ Compute automergeC.xcframework checksum"
    swift package compute-checksum ./automergeC.xcframework.zip