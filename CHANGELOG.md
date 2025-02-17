# Changelog

All notable changes to this project will be documented in this file.

## [0.1.1] - 2025-02-17

### Added
- **Textual Progress Bar Mode:** Displays progress as "27% [========----------------------] 62.7s".
- Additional styling options:
  - Prefix/Suffix text support.
  - Bold and Underline styling via ANSI codes.
  - Background color support for spinner output.
- Theme configuration: Supply a hashtable to predefine styling presets (including custom spinner characters, colors, etc.).
- Gradient progress bar customization with optional custom gradient definitions.

### Fixed
- Improved ANSI styling consistency in progress bar displays.

## [0.1.0] - 2024-01-XX

### Added
- Initial release with basic spinner functionality (Start-Spinner, Stop-Spinner, Write-SpinnerText).
- Unicode spinner characters.
- Cross-platform support (Windows, macOS, Linux).
- Basic test suite.
- GitHub Actions CI pipeline.
