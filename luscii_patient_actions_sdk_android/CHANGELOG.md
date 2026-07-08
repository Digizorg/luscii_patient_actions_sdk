# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.11.0+1] - 2026-07-08

### Changed
- Bumped version to `0.11.0+1` to align with the federated package release.
- Updated platform interface dependency constraint to `^0.11.0`.

## [0.10.2+1] - 2026-07-06

### Fixed
- Made Android `initialize` idempotent in the plugin: if already initialized, it now returns success without creating a new SDK instance.
- Made Android authentication idempotent in the plugin: if already authenticated, `authenticate` now returns success without calling the native SDK again.
- Reset tracked authentication state on first `initialize` and when native calls return `UnauthenticatedException`.

### Changed
- Updated platform interface dependency constraint to `^0.10.2`.

## [0.10.1+1] - 2026-06-29

### Changed
- Bumped package version to `0.10.1+1` to align with the federated package release.
- Updated platform interface dependency constraint to `^0.10.1`.

## [0.10.0+1] - 2026-05-12

### Changed
- Updated com.luscii:sdk to 0.10.0
- Removed conditional SDK selection based on Gradle properties.
- Updated Hilt from `2.57.2` to `2.58`.

## [0.9.0+1] - 2026-03-23

### Added
- Added caching layer, improving the speed of `launchAction` by keeping action objects in memory.

## [0.8.1+1] - 2026-01-23

### Fixed
- Fixed bug where `isPlanned`, `isSelfCare` and `isExtra` were null.
- Renamed `getSelfcareActions` to `getSelfCareActions`.

## [0.8.0+2] - 2026-01-21

### Fixed
- Updated iOS Podspec version to match package version.

## [0.8.0+1] - 2026-01-21

### Added
- Added support for configuring SDK environments (Production, Acceptance, Test) via Gradle properties.

## [0.7.0+1] - 2026-01-20

### Added
- Added getSelfcareActions call for iOS and Android

## [0.6.0+1] - 2025-11-24

### Changed
- Updated com.luscii:sdk to 0.8.2
- Updated Hilt to 2.57.2

## [0.5.0+1] - 2025-10-20

### Changed
- Initial release preparation
- Android implementation of luscii_patient_actions_sdk plugin

[unreleased]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.7.0+1...HEAD
[0.7.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.6.0+1...v0.7.0+1
[0.6.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.5.0+1...v0.6.0+1
[0.5.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/releases/tag/v0.5.0+1
