// swift-tools-version:5.2

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
        .package(url: "https://github.com/evolution-app/ZeroMQ.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Main",
            dependencies: [
                "Client", 
                "Server",
                .product(name: "ZeroMQKit", package: "ZeroMQ")
            ]
        ),
        .target(
            name: "Client",
            dependencies: [
                "ZeroMQSwiftKit",
                .product(name: "ZeroMQKit", package: "ZeroMQ")
            ]
        ),
        .target(
            name: "Server",
            dependencies: [
                "ZeroMQSwiftKit",
                .product(name: "ZeroMQKit", package: "ZeroMQ")
            ]
        ),
        .target(
            name: "ZeroMQSwiftKit",
            dependencies: [
                .product(name: "ZeroMQKit", package: "ZeroMQ")
            ]
        ),
    ]
)
