// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ReChannelSDK",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "ReChannelSDK",
            targets: ["ReChannelSDK"]
        ),
    ],
    targets: [
        .target(
            name: "ReChannelSDK",
            path: "Sources/ReChannelSDK"
        ),
        .testTarget(
            name: "ReChannelSDKTests",
            dependencies: ["ReChannelSDK"],
            path: "Tests/ReChannelSDKTests"
        ),
    ]
)
