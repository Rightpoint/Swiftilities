// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftilities",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_11),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "Swiftilities",
            targets: ["Swiftilities"]),
    ],
    targets: [
        .target(
            name: "Swiftilities",
            dependencies: [],
            path: "Pod/Classes"),
        .testTarget(
            name: "SwiftilitiesTests",
            dependencies: ["Swiftilities"],
            path: "Example/Tests"),
    ]
)
