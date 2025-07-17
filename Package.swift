// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessibilityBuild",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AccessibilityBuild",
            targets: ["AccessibilityBuild"]
        ),
    ],
    targets: [
        .target(
            name: "AccessibilityBuild",
            dependencies: [],
            path: ".",
            sources: [
                "App.swift",
                "Views",
                "Models", 
                "Utilities"
            ]
        ),
    ]
) 