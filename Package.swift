// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Movies",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "Movies",
            targets: ["AppModule"],
            bundleIdentifier: "lat.cristian.Movies",
            teamIdentifier: "V73WZ9Y4HH",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .movieReel),
            accentColor: .presetColor(.teal),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)