import 'package:flutter/material.dart';

/// Contains optimized spacing utilities, constants, and responsive widgets.
///
/// This file provides a comprehensive system for managing spacing and responsive layouts
/// in a Flutter application. It leverages compile-time constants, caching, and
/// pre-calculated values for maximum performance. It's designed to work seamlessly
/// with an optimized breakpoint system.
///
/// Key features include:
/// - `SpacingConstants`: Pre-defined spacing values for various screen breakpoints.
/// - `OptimizedSpacing`: A class for accessing responsive spacing values with aggressive caching.
/// - Responsive Widgets: `Gap`, `ResponsiveBox`, `ResponsiveSwitch`, `FastGrid` for building UIs.
/// - Figma Integration: Helper extensions to convert Figma spacing values.
/// - Utility Functions: Inline responsive value selectors.

// ============================================================================
// COMPILE-TIME SPACING CONSTANTS
// ============================================================================

/// Defines pre-calculated spacing values and scales for different breakpoints.
///
/// These constants are used by [OptimizedSpacing] to provide responsive
/// spacing values with O(1) lookup performance. The indices of the lists
/// correspond to breakpoint indices (0: phoneSmall, 1: phoneMedium, ..., 7: desktop).
abstract class SpacingConstants {
  /// Base spacing units (in logical pixels) for each breakpoint.
  /// These values typically start from a 4dp base and scale responsively.
  /// Indices correspond to breakpoints:
  /// 0: phoneSmall, 1: phoneMedium, 2: phoneLarge, 3: tabletSmall,
  /// 4: tabletMedium, 5: tabletLarge, 6: tabletXLarge, 7: desktop.
  static const List<double> baseValues = [
    4.0, // phoneSmall
    4.6, // phoneMedium
    5.2, // phoneLarge
    6.0, // tabletSmall
    6.8, // tabletMedium
    7.6, // tabletLarge
    8.0, // tabletXLarge
    8.0, // desktop
  ];

  /// Multipliers for calculating margins for each breakpoint.
  /// Margin is typically `baseValue * marginScale`.
  /// Example values (dp):
  /// - phoneSmall: 4.0 * 4.0 = 16dp
  /// - desktop: 8.0 * 10.0 = 80dp
  /// Indices correspond to breakpoints.
  static const List<double> marginScale = [
    4.0, // phoneSmall: 16dp
    4.0, // phoneMedium: 18.4dp
    5.0, // phoneLarge: 26dp
    6.0, // tabletSmall: 36dp
    7.0, // tabletMedium: 47.6dp
    8.0, // tabletLarge: 60.8dp
    9.0, // tabletXLarge: 72dp
    10.0, // desktop: 80dp
  ];

  /// Multipliers for calculating gutter spacing for each breakpoint.
  /// Gutter is typically `baseValue * gutterScale`.
  /// Indices correspond to breakpoints.
  static const List<double> gutterScale = [2.0, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0];

  /// Defines the number of grid columns for portrait and landscape orientations for each breakpoint.
  /// Each inner list is `[portraitColumns, landscapeColumns]`.
  /// Indices correspond to breakpoints.
  static const List<List<int>> gridColumns = [
    [1, 2], // phoneSmall
    [1, 2], // phoneMedium
    [2, 3], // phoneLarge
    [2, 3], // tabletSmall
    [3, 4], // tabletMedium
    [4, 5], // tabletLarge
    [5, 6], // tabletXLarge
    [6, 6], // desktop
  ];

  /// Defines the maximum content width for each breakpoint.
  /// For smaller devices, this can be `double.infinity` to allow full width.
  /// For larger devices, it constrains the content width for better readability.
  /// Indices correspond to breakpoints.
  static const List<double> maxContentWidth = [
    double.infinity, // phoneSmall
    double.infinity, // phoneMedium
    double.infinity, // phoneLarge
    680, // tabletSmall
    760, // tabletMedium
    840, // tabletLarge
    1000, // tabletXLarge
    1200, // desktop
  ];
}

// ============================================================================
// OPTIMIZED SPACING CLASS
// ============================================================================

/// Provides ultra-fast spacing calculations with cached values for responsive design.
///
/// This class retrieves screen and orientation details from [BuildContext] and
/// determines the current breakpoint. It then uses pre-calculated constants from
/// [SpacingConstants] to provide various spacing values (margins, gutters, semantic sizes).
///
/// An instance of [OptimizedSpacing] is cached to avoid repeated calculations if
/// breakpoint, RTL status, and landscape orientation remain unchanged.
class OptimizedSpacing {
  /// Private constructor to create an instance of [OptimizedSpacing].
  /// Use the factory [OptimizedSpacing.of] to get an instance.
  const OptimizedSpacing._(
    this.breakpointIndex,
    this.isRTL,
    this.isLandscape,
    this.screenWidth,
  );

  /// The index of the current breakpoint (0 for phoneSmall, up to 7 for desktop).
  final int breakpointIndex;

  /// True if the current text direction is Right-to-Left.
  final bool isRTL;

  /// True if the device is currently in landscape orientation.
  final bool isLandscape;

  /// The current screen width in logical pixels.
  final double screenWidth;

  /// Cached instance of [OptimizedSpacing] to avoid repeated calculations.
  static OptimizedSpacing? _cached;

  /// The breakpoint index of the cached instance.
  static int? _lastBreakpointIndex;

  /// The RTL status of the cached instance.
  static bool? _lastIsRTL;

  /// The landscape status of the cached instance.
  static bool? _lastIsLandscape;

  /// Factory constructor that provides an [OptimizedSpacing] instance.
  ///
  /// It uses aggressive caching: if the breakpoint, RTL status, and landscape orientation
  /// haven't changed since the last call, it returns the cached instance. Otherwise,
  /// it creates a new instance and updates the cache.
  ///
  /// Requires [BuildContext] to access [MediaQuery] and [Directionality].
  factory OptimizedSpacing.of(BuildContext context) {
    // Get required values with minimal MediaQuery calls
    final size = MediaQuery.sizeOf(context);
    final breakpointIndex = _getBreakpointIndex(size.shortestSide);
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final isLandscape = size.width > size.height;

    // Return cached instance if nothing changed
    if (_cached != null &&
        _lastBreakpointIndex == breakpointIndex &&
        _lastIsRTL == isRTL &&
        _lastIsLandscape == isLandscape) {
      return _cached!;
    }

    // Update cache
    _lastBreakpointIndex = breakpointIndex;
    _lastIsRTL = isRTL;
    _lastIsLandscape = isLandscape;
    _cached = OptimizedSpacing._(breakpointIndex, isRTL, isLandscape, size.width);

    return _cached!;
  }

  /// Determines the breakpoint index based on the given width (typically screen's shortest side).
  ///
  /// Uses a predefined list of breakpoints. This implementation uses a reverse linear search,
  /// which is efficient for a small, fixed number of breakpoints.
  /// The breakpoints are: 375.0, 430.0, 500.0, 680.0, 820.0, 1000.0, 1200.0.
  /// Returns an index from 0 (phoneSmall) to 7 (desktop).
  static int _getBreakpointIndex(double width) {
    // Breakpoint thresholds (minWidth for each breakpoint starting from phoneMedium)
    const breakpoints = [375.0, 430.0, 500.0, 680.0, 820.0, 1000.0, 1200.0];

    // Iterate downwards to find the matching breakpoint
    // If width >= breakpoints[i], then it falls into breakpoint i+1
    // e.g. if width is 400, it's >= 375 (breakpoints[0]), so it's index 1 (phoneMedium)
    for (int i = breakpoints.length - 1; i >= 0; i--) {
      if (width >= breakpoints[i]) return i + 1;
    }
    return 0; // phoneSmall (if width is less than breakpoints[0])
  }

  // ============================================================================
  // CORE SPACING VALUES (O(1) lookups)
  // ============================================================================

  /// The base spacing unit for the current breakpoint. (e.g., 4.0dp to 8.0dp).
  double get base => SpacingConstants.baseValues[breakpointIndex];

  /// The standard margin for the current breakpoint. Calculated as `base * marginScale`.
  double get margin => base * SpacingConstants.marginScale[breakpointIndex];

  /// The standard gutter spacing for the current breakpoint. Calculated as `base * gutterScale`.
  double get gutter => base * SpacingConstants.gutterScale[breakpointIndex];

  // Semantic spacing (pre-calculated multipliers for common use cases)

  /// Micro spacing, typically 1-2dp. `base * 0.25`.
  double get micro => base * 0.25;

  /// Extra small spacing, typically 2-4dp. `base * 0.5`.
  double get xs => base * 0.5;

  /// Small spacing, typically 4-8dp. Equal to `base`.
  double get sm => base;

  /// Medium spacing, typically 8-16dp. `base * 2`.
  double get md => base * 2;

  /// Large spacing, typically 12-24dp. `base * 3`.
  double get lg => base * 3;

  /// Extra large spacing, typically 16-32dp. `base * 4`.
  double get xl => base * 4;

  /// Extra-extra large spacing, typically 24-48dp. `base * 6`.
  double get xxl => base * 6;

  /// Extra-extra-extra large spacing, typically 32-64dp. `base * 8`.
  double get xxxl => base * 8;

  /// Huge spacing, typically 48-96dp. `base * 12`.
  double get huge => base * 12;

  /// Massive spacing, typically 64-128dp. `base * 16`.
  double get massive => base * 16;

  // ============================================================================
  // DEVICE TYPE CHECKS (Based on breakpointIndex)
  // ============================================================================

  /// Returns `true` if the current breakpoint is considered a mobile device.
  /// (phoneSmall, phoneMedium, phoneLarge - breakpointIndex <= 2).
  bool get isMobile => breakpointIndex <= 2;

  /// Returns `true` if the current breakpoint is considered a tablet device.
  /// (tabletSmall, tabletMedium, tabletLarge, tabletXLarge - breakpointIndex >= 3 && <= 6).
  bool get isTablet => breakpointIndex >= 3 && breakpointIndex <= 6;

  /// Returns `true` if the current breakpoint is considered a desktop device.
  /// (desktop - breakpointIndex == 7).
  bool get isDesktop => breakpointIndex == 7;

  /// Returns `true` if the current breakpoint is considered a small device.
  /// (phoneSmall, phoneMedium - breakpointIndex <= 1).
  bool get isSmall => breakpointIndex <= 1;

  /// Returns `true` if the current breakpoint is considered a large device.
  /// (tabletLarge, tabletXLarge, desktop - breakpointIndex >= 5).
  bool get isLarge => breakpointIndex >= 5;

  // ============================================================================
  // LAYOUT HELPERS
  // ============================================================================

  /// The number of columns for a grid layout, considering orientation.
  /// Retrieves from [SpacingConstants.gridColumns].
  int get columns => SpacingConstants.gridColumns[breakpointIndex][isLandscape ? 1 : 0];

  /// The maximum content width for the current breakpoint.
  /// Retrieves from [SpacingConstants.maxContentWidth].
  double get maxContentWidth => SpacingConstants.maxContentWidth[breakpointIndex];

  // ============================================================================
  // PRE-BUILT PADDING (Using semantic spacing values)
  // ============================================================================

  /// Standard page padding: horizontal margin, vertical medium spacing (`md`).
  EdgeInsets get pagePadding => EdgeInsets.symmetric(
        horizontal: margin,
        vertical: md,
      );

  /// Standard card padding: `md` for mobile, `lg` for larger screens.
  EdgeInsets get cardPadding => EdgeInsets.all(isMobile ? md : lg);

  /// Standard button padding: horizontal `lg`, vertical `sm` (mobile) or `md` (larger).
  EdgeInsets get buttonPadding => EdgeInsets.symmetric(
        horizontal: lg,
        vertical: isMobile ? sm : md,
      );

  /// Standard input field padding: horizontal `md`, vertical `sm`.
  EdgeInsets get inputPadding => EdgeInsets.symmetric(
        horizontal: md,
        vertical: sm,
      );

  /// Standard list item padding: horizontal `md`, vertical `sm`.
  EdgeInsets get listItemPadding => EdgeInsets.symmetric(
        horizontal: md,
        vertical: sm,
      );

  /// Standard modal padding: `lg` on all sides.
  EdgeInsets get modalPadding => EdgeInsets.all(lg);

  // ============================================================================
  // RTL-AWARE DIRECTIONAL PADDING
  // ============================================================================

  /// Standard page padding using [EdgeInsetsDirectional] for RTL support.
  /// Horizontal margin, vertical medium spacing (`md`).
  EdgeInsetsDirectional get pageDirectionalPadding => EdgeInsetsDirectional.symmetric(
        horizontal: margin,
        vertical: md,
      );

  /// Creates [EdgeInsetsDirectional] with specified start, end, top, and bottom values.
  EdgeInsetsDirectional directional({
    double start = 0,
    double end = 0,
    double top = 0,
    double bottom = 0,
  }) =>
      EdgeInsetsDirectional.only(
        start: start,
        end: end,
        top: top,
        bottom: bottom,
      );

  /// Creates [EdgeInsetsDirectional] with symmetric horizontal padding.
  EdgeInsetsDirectional horizontalDirectional(double value) => EdgeInsetsDirectional.symmetric(horizontal: value);

  /// Creates [EdgeInsetsDirectional] with symmetric vertical padding.
  EdgeInsetsDirectional verticalDirectional(double value) => EdgeInsetsDirectional.symmetric(vertical: value);

  // ============================================================================
  // RTL-AWARE ALIGNMENT HELPERS
  // ============================================================================

  /// Returns [Alignment.centerLeft] for LTR and [Alignment.centerRight] for RTL.
  Alignment get startAlignment => isRTL ? Alignment.centerRight : Alignment.centerLeft;

  /// Returns [Alignment.centerRight] for LTR and [Alignment.centerLeft] for RTL.
  Alignment get endAlignment => isRTL ? Alignment.centerLeft : Alignment.centerRight;

  /// Returns [CrossAxisAlignment.start] for LTR and [CrossAxisAlignment.end] for RTL.
  CrossAxisAlignment get startCross => isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start;

  /// Returns [CrossAxisAlignment.end] for LTR and [CrossAxisAlignment.start] for RTL.
  CrossAxisAlignment get endCross => isRTL ? CrossAxisAlignment.start : CrossAxisAlignment.end;

  /// Returns [MainAxisAlignment.start] for LTR and [MainAxisAlignment.end] for RTL.
  MainAxisAlignment get startMain => isRTL ? MainAxisAlignment.end : MainAxisAlignment.start;

  /// Returns [MainAxisAlignment.end] for LTR and [MainAxisAlignment.start] for RTL.
  MainAxisAlignment get endMain => isRTL ? MainAxisAlignment.start : MainAxisAlignment.end;

  /// Returns [TextAlign.left] for LTR and [TextAlign.right] for RTL.
  TextAlign get startText => isRTL ? TextAlign.right : TextAlign.left;

  /// Returns [TextAlign.right] for LTR and [TextAlign.left] for RTL.
  TextAlign get endText => isRTL ? TextAlign.left : TextAlign.right;

  // ============================================================================
  // RESPONSIVE VALUE SELECTOR
  // ============================================================================

  /// Selects a value based on the current device type (mobile, tablet, desktop).
  ///
  /// Provide specific values for [phone], [tablet], and [desktop].
  /// If a specific value for the current device type is null or not provided,
  /// it falls back to the next larger category or ultimately to [fallback].
  ///
  /// Order of preference:
  /// - If [isDesktop] and [desktop] is not null, returns [desktop].
  /// - Else if [isTablet] and [tablet] is not null, returns [tablet].
  /// - Else if [isMobile] and [phone] is not null, returns [phone].
  /// - Otherwise, returns [fallback].
  T responsive<T>({
    T? phone,
    T? tablet,
    T? desktop,
    required T fallback,
  }) {
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    if (isMobile && phone != null) return phone;
    return fallback;
  }

  /// Clears the cached [OptimizedSpacing] instance.
  ///
  /// This should be called if there's a significant app-wide change
  /// that might affect spacing calculations (e.g., dynamic theme changes
  /// that alter MediaQuery, though typically MediaQuery changes trigger rebuilds
  /// that would naturally update the cache via `OptimizedSpacing.of`).
  /// This is mainly for specific edge cases or manual cache control.
  static void clearCache() {
    _cached = null;
    _lastBreakpointIndex = null;
    _lastIsRTL = null;
    _lastIsLandscape = null;
  }
}

// ============================================================================
// CONVENIENCE EXTENSIONS
// ============================================================================

/// Extension on [BuildContext] to provide easy access to [OptimizedSpacing]
/// and related device checks.
extension OptimizedSpacingContext on BuildContext {
  /// Gets the [OptimizedSpacing] instance for the current context.
  /// Equivalent to `OptimizedSpacing.of(this)`.
  OptimizedSpacing get spacing => OptimizedSpacing.of(this);

  // Quick device checks directly on context.

  /// Returns `true` if the current breakpoint is mobile via `context.spacing`.
  bool get isMobile => spacing.isMobile;

  /// Returns `true` if the current breakpoint is tablet via `context.spacing`.
  bool get isTablet => spacing.isTablet;

  /// Returns `true` if the current breakpoint is desktop via `context.spacing`.
  bool get isDesktop => spacing.isDesktop;

  /// Returns `true` if the current text direction is RTL via `context.spacing`.
  bool get isRTL => spacing.isRTL;
}

// ============================================================================
// OPTIMIZED RESPONSIVE WIDGETS
// ============================================================================

/// A widget that provides a responsive gap (empty space) based on semantic sizes.
///
/// It uses [SizedBox.square] with dimensions determined by the current breakpoint's
/// semantic spacing values (e.g., `micro`, `sm`, `lg`).
class Gap extends StatelessWidget {
  /// Creates a responsive gap of a specific semantic size.
  ///
  /// The actual dimension is resolved from [OptimizedSpacing] at build time.
  const Gap(this.size, {super.key});

  /// Creates a gap with `micro` spacing.
  const Gap.micro({super.key}) : size = _GapSize.micro;

  /// Creates a gap with `xs` (extra small) spacing.
  const Gap.xs({super.key}) : size = _GapSize.xs;

  /// Creates a gap with `sm` (small) spacing.
  const Gap.sm({super.key}) : size = _GapSize.sm;

  /// Creates a gap with `md` (medium) spacing.
  const Gap.md({super.key}) : size = _GapSize.md;

  /// Creates a gap with `lg` (large) spacing.
  const Gap.lg({super.key}) : size = _GapSize.lg;

  /// Creates a gap with `xl` (extra large) spacing.
  const Gap.xl({super.key}) : size = _GapSize.xl;

  /// Creates a gap with `xxl` (extra-extra large) spacing.
  const Gap.xxl({super.key}) : size = _GapSize.xxl;

  /// Creates a gap with `xxxl` (extra-extra-extra large) spacing.
  const Gap.xxxl({super.key}) : size = _GapSize.xxxl;

  /// Creates a gap with `huge` spacing.
  const Gap.huge({super.key}) : size = _GapSize.huge;

  /// Creates a gap with `massive` spacing.
  const Gap.massive({super.key}) : size = _GapSize.massive;

  /// The semantic size of the gap.
  final _GapSize size;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing; // Access OptimizedSpacing

    final value = switch (size) {
      _GapSize.micro => spacing.micro,
      _GapSize.xs => spacing.xs,
      _GapSize.sm => spacing.sm,
      _GapSize.md => spacing.md,
      _GapSize.lg => spacing.lg,
      _GapSize.xl => spacing.xl,
      _GapSize.xxl => spacing.xxl,
      _GapSize.xxxl => spacing.xxxl,
      _GapSize.huge => spacing.huge,
      _GapSize.massive => spacing.massive,
    };

    return SizedBox.square(dimension: value);
  }
}

/// Enum representing semantic gap sizes for the [Gap] widget.
enum _GapSize { micro, xs, sm, md, lg, xl, xxl, xxxl, huge, massive }

/// An optimized responsive container that applies appropriate padding and maximum width.
///
/// By default, it uses `pagePadding` from [OptimizedSpacing] and `maxContentWidth`.
/// These can be overridden.
class ResponsiveBox extends StatelessWidget {
  /// Creates a responsive container.
  ///
  /// - [child]: The content of the container.
  /// - [padding]: Custom padding. If null, defaults to `context.spacing.pagePadding`.
  /// - [margin]: Custom margin for the container.
  /// - [maxWidth]: Custom maximum width. If null, defaults to `context.spacing.maxContentWidth`.
  /// - [centerContent]: If true, centers the child within the container using [Alignment.center].
  const ResponsiveBox({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.maxWidth,
    this.centerContent = false,
  });

  /// The widget below this widget in the tree.
  final Widget child;

  /// The padding to apply around the child.
  /// Defaults to `context.spacing.pagePadding`.
  final EdgeInsetsGeometry? padding;

  /// The margin to apply around the container.
  final EdgeInsetsGeometry? margin;

  /// The maximum width for the content.
  /// Defaults to `context.spacing.maxContentWidth`.
  final double? maxWidth;

  /// Whether to center the content within the box.
  final bool centerContent;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing; // Access OptimizedSpacing

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? spacing.maxContentWidth,
      ),
      padding: padding ?? spacing.pagePadding,
      margin: margin,
      alignment: centerContent ? Alignment.center : null,
      child: child,
    );
  }
}

/// A widget that switches its content based on the current device type (mobile, tablet, desktop).
///
/// It expects either a `Widget` or a `Widget Function()` for its [phone], [tablet],
/// [desktop], and [fallback] parameters.
///
/// Throws an [ArgumentError] if the resolved value is not a [Widget] or [Widget Function()].
class ResponsiveSwitch<T> extends StatelessWidget {
  /// Creates a responsive switch.
  ///
  /// - [phone]: The widget or builder to use for mobile.
  /// - [tablet]: The widget or builder to use for tablet.
  /// - [desktop]: The widget or builder to use for desktop.
  /// - [fallback]: The widget or builder to use if no specific type matches or is provided.
  ///
  /// The type `T` should be `Widget` or `Widget Function()`.
  const ResponsiveSwitch({
    super.key,
    this.phone,
    this.tablet,
    this.desktop,
    required this.fallback,
  });

  /// The content for phone-sized screens. Can be a `Widget` or `Widget Function()`.
  final T? phone;

  /// The content for tablet-sized screens. Can be a `Widget` or `Widget Function()`.
  final T? tablet;

  /// The content for desktop-sized screens. Can be a `Widget` or `Widget Function()`.
  final T? desktop;

  /// The fallback content if no specific screen size matches. Can be a `Widget` or `Widget Function()`.
  final T fallback;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing; // Access OptimizedSpacing

    late final T value;
    if (spacing.isDesktop && desktop != null) {
      value = desktop!;
    } else if (spacing.isTablet && tablet != null) {
      value = tablet!;
    } else if (spacing.isMobile && phone != null) {
      value = phone!;
    } else {
      value = fallback;
    }

    // Handle both Widget and Widget Function() types
    if (value is Widget) {
      return value as Widget;
    } else if (value is Widget Function()) {
      return (value as Widget Function())();
    } else {
      throw ArgumentError(
          'ResponsiveSwitch can only handle Widget or Widget Function() types. Received type: ${value.runtimeType}');
    }
  }
}

/// A fast responsive grid layout that uses pre-calculated column counts.
///
/// It arranges [children] in a [Wrap] layout. The number of columns,
/// spacing, and run spacing can be customized or will default to values
/// from [OptimizedSpacing] (gutter for spacing, dynamic columns based on breakpoint/orientation).
class FastGrid extends StatelessWidget {
  /// Creates a fast responsive grid.
  ///
  /// - [children]: The list of widgets to display in the grid.
  /// - [spacing]: Horizontal spacing between items. Defaults to `context.spacing.gutter`.
  /// - [runSpacing]: Vertical spacing between rows. Defaults to [spacing].
  /// - [columns]: Number of columns. Defaults to `context.spacing.columns`.
  const FastGrid({
    super.key,
    required this.children,
    this.spacing,
    this.runSpacing,
    this.columns,
  });

  /// The widgets to lay out in the grid.
  final List<Widget> children;

  /// The spacing between items in the main axis (horizontal).
  /// Defaults to `context.spacing.gutter`.
  final double? spacing;

  /// The spacing between runs (rows) in the cross axis (vertical).
  /// Defaults to the value of [spacing].
  final double? runSpacing;

  /// The number of columns in the grid.
  /// Defaults to `context.spacing.columns`.
  final int? columns;

  @override
  Widget build(BuildContext context) {
    final appSpacing = context.spacing; // Access OptimizedSpacing
    final gridSpacing = spacing ?? appSpacing.gutter;
    final gridRunSpacing = runSpacing ?? gridSpacing; // Default runSpacing to spacing
    final gridColumns = columns ?? appSpacing.columns;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate item width based on available width, spacing, and column count
        final itemWidth = (constraints.maxWidth - (gridSpacing * (gridColumns - 1))) / gridColumns;

        return Wrap(
          spacing: gridSpacing,
          runSpacing: gridRunSpacing,
          textDirection: appSpacing.isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: children
              .map((child) => SizedBox(
                    width: itemWidth.isFinite && itemWidth > 0 ? itemWidth : null, // Ensure valid width
                    child: child,
                  ))
              .toList(),
        );
      },
    );
  }
}

// ============================================================================
// FIGMA INTEGRATION HELPERS
// ============================================================================

/// Extension on [OptimizedSpacing] to provide helper methods for converting
/// Figma design values into the app's responsive spacing system.
extension FigmaSpacing on OptimizedSpacing {
  /// Converts common Figma 8pt grid values to the app's semantic spacing values.
  ///
  /// - 4pt -> `xs`
  /// - 8pt -> `sm`
  /// - 12pt -> `md * 0.75` (approx)
  /// - 16pt -> `md`
  /// - 24pt -> `lg`
  /// - 32pt -> `xl`
  /// - 48pt -> `xxl`
  /// - 64pt -> `xxxl`
  /// - 96pt -> `huge`
  ///
  /// For other values, it calculates based on `(points / 8.0) * sm`.
  /// [points] is the spacing value from Figma (e.g., 8, 16).
  double figma(int points) {
    // Common Figma values mapped to our system
    return switch (points) {
      4 => xs,
      8 => sm,
      12 => md * 0.75, // Approximation, adjust if needed
      16 => md,
      24 => lg,
      32 => xl,
      48 => xxl,
      64 => xxxl,
      96 => huge,
      _ => (points / 8.0) * sm, // Fallback calculation for non-standard Figma values
    };
  }

  /// Auto-scales a Figma spacing value (based on an 8pt grid) according to the
  /// current breakpoint's base scaling factor.
  ///
  /// This allows Figma values to adapt more dynamically across different screen sizes.
  /// The scaling factor is derived from how the current `base` spacing relates to the
  /// typical phone-small base (4.0).
  ///
  /// [points] is the spacing value from Figma (e.g., 8, 16).
  double figmaScaled(int points) {
    final baseRatio = base / 4.0; // Our scaling factor relative to the smallest base
    return (points / 8.0) * sm * baseRatio; // Scale the normalized Figma value
  }
}

// ============================================================================
// UTILITY FUNCTIONS
// ============================================================================

/// A utility function for selecting a value responsively, for inline use.
///
/// This is a top-level function wrapper around `context.spacing.responsive<T>()`.
/// See [OptimizedSpacing.responsive] for detailed behavior.
///
/// - [context]: The build context.
/// - [phone]: Value for phone.
/// - [tablet]: Value for tablet.
/// - [desktop]: Value for desktop.
/// - [fallback]: Fallback value.
T responsive<T>(
  BuildContext context, {
  T? phone,
  T? tablet,
  T? desktop,
  required T fallback,
}) {
  return context.spacing.responsive<T>(
    phone: phone,
    tablet: tablet,
    desktop: desktop,
    fallback: fallback,
  );
}

/// Creates responsive [EdgeInsets] based on device type.
///
/// This is a convenience function that uses the [responsive] utility.
///
/// - [context]: The build context.
/// - [phone]: EdgeInsets for phone.
/// - [tablet]: EdgeInsets for tablet.
/// - [desktop]: EdgeInsets for desktop.
/// - [fallback]: Fallback EdgeInsets.
EdgeInsets responsivePadding(
  BuildContext context, {
  EdgeInsets? phone,
  EdgeInsets? tablet,
  EdgeInsets? desktop,
  required EdgeInsets fallback,
}) {
  return responsive<EdgeInsets>(
    context,
    phone: phone,
    tablet: tablet,
    desktop: desktop,
    fallback: fallback,
  );
}
