// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "luscii_patient_actions_sdk_ios",
    platforms: [
        .iOS("15.5")
    ],
    products: [
        .library(name: "luscii-patient-actions-sdk-ios", targets: ["luscii_patient_actions_sdk_ios"])
    ],
    dependencies: [
        // The Actions SDK. The `ActionsKit` product bundles the Actions, Centraal,
        // HTTPii and Measurements xcframeworks, so `import Actions` works transitively.
        .package(url: "https://github.com/Luscii/actions-sdk-ios.git", exact: "2.2.0")
    ],
    targets: [
        .target(
            name: "luscii_patient_actions_sdk_ios",
            dependencies: [
                .product(name: "ActionsKit", package: "actions-sdk-ios")
            ],
            resources: [
                // If your plugin requires a privacy manifest, for example if it uses any required
                // reason APIs, update the PrivacyInfo.xcprivacy file to describe your plugin's
                // privacy impact, and then uncomment these lines. For more information, see
                // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                // .process("PrivacyInfo.xcprivacy"),

                // If you have other resources that need to be bundled with your plugin, refer to
                // the following instructions to add them:
                // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
            ]
        )
    ]
)
