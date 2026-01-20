# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.0] - 2026-01-20

### Changed
- Updated `build.gradle` to allow overriding the Luscii SDK artifact via `lusciiSdkArtifact` Gradle property for environment switching.
- Updated `initialize` method to log a warning if an environment other than production is passed at runtime (Android relies on build-time config).

## [0.6.0+1] - 2025-11-24

### Changed
- Updated com.luscii:sdk to 0.8.2
- Updated Hilt to 2.57.2

## [0.5.0+1] - 2025-10-20

### Changed
- Initial release preparation
- Android implementation of luscii_patient_actions_sdk plugin

[unreleased]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.6.0+1...HEAD
[0.6.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/compare/v0.5.0+1...v0.6.0+1
[0.5.0+1]: https://github.com/Luscii/luscii_patient_actions_sdk/releases/tag/v0.5.0+1
