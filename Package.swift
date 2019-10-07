// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "Graphite",
  products: [
    .library(name: "Graphite", targets: ["Graphite"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "Graphite", dependencies: []),
    .testTarget(name: "GraphiteTests", dependencies: ["Graphite"]),
  ]
)
