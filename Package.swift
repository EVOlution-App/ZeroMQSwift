// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZeroMQServer",
    products: [
        .executable(
            name: "Main",
            targets: ["Main"]
        ),
        .library(
            name: "ZeroMQServerKit",
            targets: ["ZeroMQServerKit"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/unnamedd/ZeroMQ.git", from: "1.1.1"),
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: ["ZeroMQServerKit"]
        ),
        .target(
            name: "ZeroMQServerKit",
            dependencies: ["ZeroMQKit"]
        ),
    ]
)
