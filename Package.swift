// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-mysql",
  platforms: [
    .macOS(.v14),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "MySQL",
      targets: ["MySQL"]
    ),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "MySQL",
      dependencies: [
        .target(name: "CMySQL"),
      ]
    ),
    .testTarget(
      name: "MySQLTests",
      dependencies: ["MySQL"]
    ),
    .systemLibrary(
      name: "CMySQL",
      path: "Sources/CMySQL",
      pkgConfig: "CMySQL",
      providers: [
        .brew(["cmysql"]),
        .apt(["libmysqlclient-dev"])
      ]
    ),
  ]
)
