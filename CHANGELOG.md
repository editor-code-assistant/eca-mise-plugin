# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - Unreleased

### Added
- Support for [eca-cli](https://github.com/editor-code-assistant/eca-cli). Install the plugin under the name `eca-cli` to get it.

### Fixed
- Report release dates (`created_at`) so mise's `minimum_release_age` works without "no release date" warnings
- Retry GitHub requests without auth when the configured token is rejected (401)

## [1.0.0] - 2025-09-25

### Added
- Initial release of mise-eca-plugin
- Support for all ECA platforms (Linux x64/ARM64, macOS Intel/Apple Silicon, Windows x64)
- Automatic version detection from GitHub releases API
- SHA256 checksum verification when available
- Cross-platform installation with proper permissions
- Installation verification to ensure binary works
- Comprehensive test suite

### Features
- Downloads ECA binaries from official GitHub releases
- Uses static Linux builds for better compatibility
- Sets executable permissions on Unix systems
- Configures PATH environment variable
- Supports all ECA release versions
