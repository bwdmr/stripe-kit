// swift-tools-version:6.2

import PackageDescription

let package = Package(
    name: "stripe-kit",
    platforms: [ .macOS(.v15) ],
    products: [
        .library(name: "StripeKit", targets: ["StripeKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.30.2"),
        .package(url: "https://github.com/apple/swift-crypto.git", from: "4.2.0"),
    ],
    targets: [
        .target(name: "StripeKit", dependencies: [
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "Crypto", package: "swift-crypto"),
        ]),
        .testTarget(name: "StripeKitTests", dependencies: [
            .target(name: "StripeKit")
        ])
    ]
)
