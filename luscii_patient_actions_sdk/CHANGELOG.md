# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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
