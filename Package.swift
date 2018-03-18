// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZeroMQSwift",
    products: [
        .executable(
            name: "Main",
            targets: ["Main"]
        ),
        .library(
            name: "ZeroMQSwiftKit",
            targets: ["ZeroMQSwiftKit"]
        ),
        .library(
            name: "Client",
            targets: ["Client"]
        ),
        .library(
            name: "Server",
            targets: ["Server"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/unnamedd/ZeroMQ.git", from: "1.1.1"),
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: ["ZeroMQSwiftKit", "Client", "Server"]
        ),
        .target(
            name: "Client",
            dependencies: ["ZeroMQSwiftKit"]
        ),
        .target(
            name: "Server",
            dependencies: ["ZeroMQSwiftKit"]
        ),
        .target(
            name: "ZeroMQSwiftKit",
            dependencies: ["ZeroMQKit"]
        ),
    ]
)
