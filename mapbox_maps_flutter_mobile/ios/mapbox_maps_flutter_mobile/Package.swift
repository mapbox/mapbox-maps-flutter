// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let mapboxMapsVersion: Version = "11.26.0-SNAPSHOT-06-09--02-04.git-04704ec"

let mapboxMapsPackage = mapboxMapsVersion.description.contains("SNAPSHOT")
    ? "mapbox-maps-ios-binary"
    : "mapbox-maps-ios"

let package = Package(
    name: "mapbox_maps_flutter_mobile",
    platforms: [
        .iOS("14.0")
    ],
    products: [
        .library(name: "mapbox-maps-flutter-mobile", targets: ["mapbox_maps_flutter_mobile"])
    ],
    dependencies: [
        .package(url: "https://github.com/mapbox/\(mapboxMapsPackage).git", exact: mapboxMapsVersion)
    ],
    targets: [
        .target(
            name: "mapbox_maps_flutter_mobile",
            dependencies: [
                .product(name: "MapboxMaps", package: mapboxMapsPackage)
            ],
            resources: []
        )
    ]
)
