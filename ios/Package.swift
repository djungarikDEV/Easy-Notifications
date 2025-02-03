// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EasyNotifications",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_14)
    ],
    products: [
        .library(
            name: "EasyNotifications",
            targets: ["EasyNotifications"]
        ),
    ],
    targets: [
        .target(
            name: "EasyNotifications",
            path: "Classes"
        ),
        .testTarget(
            name: "EasyNotificationsTests",
            dependencies: ["EasyNotifications"],
            path: "Tests"
        ),
    ]
)
