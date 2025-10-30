// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TransferFeature",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "TransferFeature",
            targets: ["TransferFeature"]
        ),
    ],
    dependencies: [
            .package(path: "../../NetworkCore")
        ],
        targets: [
            .target(
                name: "TransferFeature",
                dependencies: [
                    "NetworkCore"
                ],
//                path: "Sources/TransferFeature",
//                exclude: ["include"],
//                resources: [.process(".")]
            )
        ]
    )
