// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOS-Module",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(name: "ADManager", targets: ["ADManager"]),
        .library(name: "ApiManager", targets: ["ApiManager"]),
        .library(name: "DataManager", targets: ["DataManager"]),
        .library(name: "MapManager", targets: ["MapManager"]),
        .library(name: "AudioPlayerManager", targets: ["AudioPlayerManager"]),
        .library(name: "NotificationManager", targets: ["NotificationManager"]),
        .library(name: "KFImageManager", targets: ["KFImageManager"]),
        .library(name: "UIGenerator", targets: ["UIGenerator"]) 
    ],
    dependencies: [
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", 
                 from: "11.0.0"
        ),
        .package(url: "https://github.com/Alamofire/Alamofire.git",
            from: "5.10.1"
        ),
        .package(url: "https://github.com/onevcat/Kingfisher.git",
            .upToNextMajor(from: "8.1.1")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ADManager",
            dependencies: [
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "./Sources/AD"
        ),
        .target(
            name: "ApiManager",
            dependencies: [
                .product(name: "Alamofire", package: "Alamofire")
            ],
            path: "./Sources/API"
        ),
        .target(
            name: "DataManager",
            dependencies: [],
            path: "./Sources/Data"
        ),
        .target(
            name: "MapManager",
            dependencies: [],
            path: "./Sources/Map"
        ),
        .target(
            name: "AudioPlayerManager",
            dependencies: [],
            path: "./Sources/Sound"
        ),
        .target(
            name: "NotificationManager",
            dependencies: [],
            path: "./Sources/Notification"
        ),
        .target(
            name: "KFImageManager",
            dependencies: [
                .product(name: "Kingfisher", package: "Kingfisher")
            ],
            path: "./Sources/Image"
        ),
        .target(
            name: "UIGenerator",
            dependencies: [],
            path: "./Sources/UIGenerator",
            resources: [
                .process("Examples") 
            ]
        ),
        // UIGenerator 테스트 타겟 추가
        .testTarget(
            name: "UIGeneratorTests",
            dependencies: ["UIGenerator"],
            path: "./Tests/iOS-ModuleTests"
        )
    ]
)
