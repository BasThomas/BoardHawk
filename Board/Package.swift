// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Board",
    platforms: [
        .iOS(.v14),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Board",
            targets: ["Board"]),
    ],
    targets: [
        .target(
            name: "Board",
            dependencies: []),
        .testTarget(
            name: "BoardTests",
            dependencies: ["Board"]),
    ]
)
