// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EasyNotifications",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "EasyNotifications",
            targets: ["EasyNotifications"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "EasyNotifications",
            dependencies: [],
            path: "Classes"
        )
    ]
)
