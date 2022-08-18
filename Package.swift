// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "automergeC",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_10),
    ],
    products: [
        .library(name: "automergeC", targets: ["automergeC"])
    ],
    dependencies: [
    ],
    targets: [
        .binaryTarget(
            name: "automergeC",
            url: "https://github.com/lightsprint09/automerge-swift-backend/releases/download/0.1.10/AutomergeBackend.xcframework.zip",
            checksum: "8c6895fec6cf6a4b10195fd7ef67e79e9bebb119312be1942f8cd050f7bbb2a9"
        )
    ]
)
