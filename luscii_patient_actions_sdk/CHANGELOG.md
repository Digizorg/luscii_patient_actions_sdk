# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.11.1+1] - 2026-07-16

### Fixed
- iOS: Pinned the native `actions-sdk-ios` dependency to exactly `2.2.0`, preventing unintended upgrades to newer minor versions such as `2.3.0`.

### Changed
- Bumped package version to `0.11.1+1`.

## [0.11.0+1] - 2026-07-14

### Added
- iOS: Swift Package Manager (SPM) support in the iOS implementation package.

### Changed
- Bumped federated package dependencies to `^0.11.0`.
- Bumped package version to `0.11.0+1`.

## [0.10.3+1] - 2026-07-14

### Added
- Added `logout` to clear the SDK session.

## [0.10.2+1] - 2026-07-06

### Changed
- Bumped federated package dependencies to `^0.10.2`.
- Bumped package version to `0.10.2+1`.

## [0.10.1+1] - 2026-06-29

### Fixed
- iOS: fixed a production-environment issue by setting the production environment explicitly.

### Changed
- Bumped federated package dependencies to `^0.10.1`.

## [0.10.0+1] - 2026-05-12

### Changed
- Bumped federated package dependencies to `^0.10.0`.

## [0.9.0+1] - 2026-03-23

### Added
- Added caching layer for iOS and Android, improving the speed of `launchAction` by keeping action objects in memory.

### Changed
- Bumped native Luscii iOS SDK from 2.0.0 to 2.1.0.

## [0.8.1+1] - 2026-01-23

### Fixed
- Fixed bug where `isPlanned`, `isSelfCare` and `isExtra` were null.
- Renamed `getSelfcareActions` to `getSelfCareActions`.

## [0.8.0+2] - 2026-01-21

### Fixed
- Updated iOS Podspec version to match package version.

## [0.8.0+1] - 2026-01-21

### Added
- Added support for configuring SDK environments (Production, Acceptance, Test).
- Android: Added `lusciiUseAcceptanceSdk` and `lusciiUseTestSdk` Gradle properties to select the environment.
- iOS: Added `iOSEnvironment` parameter to `initialize` method to select the environment.

## [0.7.0+1] - 2026-01-20

### Added
- Added getSelfcareActions call for iOS and Android

## [0.6.0+1] - 2025-11-24

### Changed
- Updated dependencies to latest versions

## [0.5.0+1] - 2025-10-20

### Changed
- Initial release preparation
- Updated dependencies and requirements

[unreleased]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.7.0+1...HEAD
[0.7.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.6.0+1...v0.7.0+1
[0.6.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.5.0+1...v0.6.0+1
[0.5.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/releases/tag/v0.5.0+1
