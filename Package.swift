// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "aoc2024",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-parsing.git", from: "0.13.0"),
    ],
    targets: [
        .executableTarget(
            name: "aoc2024",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Parsing", package: "swift-parsing"),
            ]
        ),
        .testTarget(
            name: "aoc2024Tests", dependencies: ["aoc2024"]
        ),
    ]
)
