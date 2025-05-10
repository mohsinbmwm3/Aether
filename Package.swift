// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Aether",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
      .library(
        name: "Aether",
        targets: ["Aether"]
      )
    ],
    targets: [
        .target(
            name: "Aether",
            dependencies: [],
            path: "Sources/Aether"
        ),
        .executableTarget(
            name: "AetherExample",
            dependencies: ["Aether"],
            path: "Examples/AetherExample"
        ),
        .testTarget(
            name: "AetherTests",
            dependencies: ["Aether"],
            path: "Tests/AetherTests"
        )
    ]
)
