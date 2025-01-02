// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "mapbox_maps_flutter",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "mapbox-maps-flutter", targets: ["mapbox_maps_flutter"])
    ],
    dependencies: [
        .package(url: "https://github.com/mapbox/mapbox-maps-ios.git", exact: "11.9.0"),
    ],
    targets: [
        .target(
            name: "mapbox_maps_flutter",
            dependencies: [
                .product(name: "MapboxMaps", package: "mapbox-maps-ios"),
            ],
            resources: []
        )
    ]
)
