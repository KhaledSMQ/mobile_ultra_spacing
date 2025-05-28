# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.2] - 2025-05-29

- **Small Fixes**:
  - Minor documentation updates for clarity
  - Remove deprecated function
  - shortened package description

## [0.1.1] - 2025-05-29

### Added

- **Comprehensive Test Suite**: Added extensive test coverage for all package components
  - **Unit Tests**:
    - `SpacingConstants` validation tests
    - `OptimizedSpacing` breakpoint detection and caching tests
    - `Breakpoint` enum and `BreakpointCache` functionality tests
    - `AppSpacing` responsive spacing tests
    - `OpticalAdjustments` visual correction tests
  - **Widget Tests**:
    - `Gap` widget dimension and sizing tests
    - `ResponsiveBox` container and padding tests
    - `ResponsiveSwitch` device-specific content switching tests
    - `FastGrid` layout and RTL support tests
    - `ResponsiveBuilder` breakpoint-based building tests
    - `ResponsiveGrid` grid layout tests
    - `ResponsiveContainer` constraint and padding tests
    - `ResponsiveGap` semantic spacing tests
    - `ResponsivePositioned` directional positioning tests
  - **Integration Tests**:
    - Cross-screen-size responsive behavior tests
    - RTL layout integration tests
    - Optical adjustments integration tests
    - Performance caching validation tests
  - **Optical Adjustments Tests**:
    - Spacing adjustment calculations
    - Asymmetric padding for LTR/RTL layouts
    - Font size adjustments for different scripts
    - Shadow generation and scaling
    - Border radius optical corrections
    - Text style adjustments with line height and letter spacing
    - Arabic text handling and font weight mapping
    - Directional padding and container balancing
    - List item margin calculations

## [0.1.0] - 2025-05-28

### Added
- **Initial release** of Mobile Ultra Spacing package
- **8 responsive breakpoints** from phoneSmall (0px) to desktop (1200px+)
- **OptimizedSpacing class** with O(1) lookup performance and aggressive caching
- **Semantic spacing system** with xs, sm, md, lg, xl, xxl, xxxl, huge, massive sizes
- **Full RTL support** with directional padding and alignment helpers
- **Ready-to-use widgets**:
    - `Gap` - Responsive spacing widget with semantic sizes
    - `ResponsiveBox` - Auto-sizing container with max-width constraints
    - `ResponsiveSwitch` - Device-specific widget switching
    - `FastGrid` - Performance-optimized responsive grid
    - `ResponsiveBuilder` - Custom responsive layout builder
- **Optical adjustments** based on design principles:
    - Typography adjustments for better readability
    - Visual spacing corrections
    - Subtle shadow generation
    - Container padding balancing
- **Figma integration helpers** for converting design values
- **Performance optimizations**:
    - Compile-time constants for spacing scales
    - Aggressive caching to avoid recalculations
    - Minimal widget rebuilds
- **Comprehensive breakpoint system** with device type detection
- **Context extensions** for easy access to spacing and device checks
- **ResponsiveValue class** for declarative responsive values

### Features
- Ultra-fast responsive spacing with caching
- 8 precise breakpoints with automatic detection
- Complete RTL language support
- Visual perception-based optical adjustments
- Ready-to-use responsive widgets
- Figma design workflow integration
- Performance-first architecture

### Supported Platforms
- Android
- iOS
- Web
- Windows
- macOS
- Linux