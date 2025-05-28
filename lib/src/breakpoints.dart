import 'package:flutter/material.dart';

import 'spacing_utils.dart';

/// Defines the different screen breakpoints used in the application.
///
/// Each breakpoint has a minimum width and a descriptive label.
/// It also provides utility getters to check the device type (phone, tablet, desktop)
/// and size category (small, large).
enum Breakpoint {
  /// Smallest phone screens, min width typically around 0 to 374.
  /// `minWidth` is 375 for matching `_getBreakpointIndex` logic in `OptimizedSpacing`.
  /// However, the effective range for `phoneSmall` (index 0) in `_getBreakpointIndex`
  /// is `width < 375`. For this enum, we use the lower bound of the *next* breakpoint
  /// as the `minWidth` for the *current* one for direct comparison.
  /// Let's adjust to represent the start of the range.
  phoneSmall(0, 'Phone Small'), // Effective range typically < 375

  /// Medium-sized phones, min width 375.
  phoneMedium(375, 'Phone Medium'), // Effective range 375 to < 430

  /// Large-sized phones, min width 430.
  phoneLarge(430, 'Phone Large'), // Effective range 430 to < 500

  /// Smallest tablet screens, min width 500.
  /// Note: `OptimizedSpacing._getBreakpointIndex` uses 500 as the threshold for `tabletSmall` (index 3).
  /// The `spacing_utils.dart` breakpoints for `_getBreakpointIndex` are:
  /// [375.0 (phoneMedium), 430.0 (phoneLarge), 500.0 (tabletSmall), 680.0 (tabletMedium),
  /// 820.0 (tabletLarge), 1000.0 (tabletXLarge), 1200.0 (desktop)]
  /// This enum's `minWidth` should align with these thresholds.
  tabletSmall(500, 'Tablet Small'), // Effective range 500 to < 680

  /// Medium-sized tablets, min width 680.
  tabletMedium(680, 'Tablet Medium'), // Effective range 680 to < 820

  /// Large-sized tablets, min width 820.
  tabletLarge(820, 'Tablet Large'), // Effective range 820 to < 1000

  /// Extra-large tablets, min width 1000.
  tabletXLarge(1000, 'Tablet XL'), // Effective range 1000 to < 1200

  /// Desktop screens, min width 1200.
  desktop(1200, 'Desktop'); // Effective range >= 1200

  /// Constant constructor for a breakpoint.
  /// - [minWidth]: The minimum shortest side width (in logical pixels) for this breakpoint.
  /// - [label]: A human-readable label for the breakpoint.
  const Breakpoint(this.minWidth, this.label);

  /// The minimum shortest side width (in logical pixels) for this breakpoint.
  final double minWidth;

  /// A human-readable label for the breakpoint (e.g., "Phone Small", "Desktop").
  final String label;

  /// Returns `true` if this breakpoint is for a phone (phoneSmall, phoneMedium, phoneLarge).
  /// Corresponds to indices 0, 1, 2.
  bool get isPhone => index <= Breakpoint.phoneLarge.index;

  /// Returns `true` if this breakpoint is for a tablet (tabletSmall, tabletMedium, tabletLarge, tabletXLarge).
  /// Corresponds to indices 3, 4, 5, 6.
  bool get isTablet => index >= Breakpoint.tabletSmall.index && index <= Breakpoint.tabletXLarge.index;

  /// Returns `true` if this breakpoint is for a desktop.
  /// Corresponds to index 7.
  bool get isDesktop => index == Breakpoint.desktop.index;

  /// Returns `true` if this breakpoint is considered "small" (phoneSmall, phoneMedium).
  /// Corresponds to indices 0, 1.
  bool get isSmall => index <= Breakpoint.phoneMedium.index;

  /// Returns `true` if this breakpoint is considered "large" (tabletLarge, tabletXLarge, desktop).
  /// Corresponds to indices 5, 6, 7.
  bool get isLarge => index >= Breakpoint.tabletLarge.index;

  /// Pre-calculated grid columns: `[portraitColumns, landscapeColumns]` for each breakpoint.
  /// Indices correspond to [Breakpoint.values] indices.
  static const List<List<int>> _gridColumns = [
    [1, 2], // phoneSmall
    [1, 2], // phoneMedium
    [2, 3], // phoneLarge
    [2, 3], // tabletSmall (was [2,3] in SpacingConstants, ensuring consistency)
    [3, 4], // tabletMedium
    [4, 5], // tabletLarge
    [5, 6], // tabletXLarge
    [6, 6], // desktop
  ];

  /// Gets the number of grid columns for this breakpoint, considering orientation.
  /// - [isLandscape]: True if the device is in landscape mode.
  /// Returns the number of columns (e.g., 2 for portrait phone, 3 for landscape phone).
  int gridColumns(bool isLandscape) => _gridColumns[index][isLandscape ? 1 : 0];
}

/// Caches the detected [Breakpoint] to avoid recalculating on every access
/// if the screen size hasn't changed.
class BreakpointCache {
  static Breakpoint? _cachedBreakpoint;
  static Size? _lastScreenSize;

  /// Detects the current [Breakpoint] based on the [screenSize]'s shortest side.
  ///
  /// Returns a cached breakpoint if the [screenSize] is the same as the last call.
  /// Otherwise, it calculates the new breakpoint, caches it, and returns it.
  /// The detection logic iterates through [Breakpoint.values] in reverse.
  static Breakpoint detect(Size screenSize) {
    if (_cachedBreakpoint != null && _lastScreenSize == screenSize) {
      return _cachedBreakpoint!;
    }

    _lastScreenSize = screenSize;
    final width = screenSize.shortestSide;

    // Iterate from largest to smallest breakpoint.
    // The first breakpoint whose minWidth is less than or equal to the screen width is chosen.
    // For example, if width is 400:
    // - desktop.minWidth (1200) > 400
    // - ...
    // - phoneMedium.minWidth (375) <= 400. This is chosen.
    // If width is 300:
    // - ...
    // - phoneSmall.minWidth (0) <= 300. This is chosen.
    for (int i = Breakpoint.values.length - 1; i >= 0; i--) {
      if (width >= Breakpoint.values[i].minWidth) {
        _cachedBreakpoint = Breakpoint.values[i];
        return _cachedBreakpoint!;
      }
    }

    // Should not be reached if Breakpoint.phoneSmall.minWidth is 0.
    // Fallback, though logic implies Breakpoint.phoneSmall should always match.
    _cachedBreakpoint = Breakpoint.phoneSmall;
    return _cachedBreakpoint!;
  }

  /// Invalidates the cached breakpoint and screen size.
  /// The next call to [detect] will force a recalculation.
  static void invalidate() {
    _cachedBreakpoint = null;
    _lastScreenSize = null;
  }
}

/// Gets the current [Breakpoint] for the given [BuildContext].
///
/// Uses [BreakpointCache] to efficiently retrieve the breakpoint.
Breakpoint currentBreakpoint(BuildContext context) {
  return BreakpointCache.detect(MediaQuery.sizeOf(context));
}

/// Provides responsive spacing values based on the current [Breakpoint].
///
/// This class is similar to [OptimizedSpacing] but is more tightly coupled with the [Breakpoint] enum.
/// It uses pre-calculated lists for base values, margin multipliers, and gutter multipliers,
/// indexed by `breakpoint.index`.
///
/// **Note:** There's an overlap in functionality and constants with `OptimizedSpacing`
/// and `SpacingConstants` from `spacing_utils.dart`. Consider consolidating
/// to a single source of truth for spacing logic if both files are used in the same project.
class AppSpacing {
  /// Private constructor. Use [AppSpacing.of] factory.
  const AppSpacing._(this.breakpoint, this.isRTL, this.screenSize);

  /// The current detected [Breakpoint].
  final Breakpoint breakpoint;

  /// True if the current text direction is Right-to-Left.
  final bool isRTL;

  /// The current screen size ([Size]).
  final Size screenSize;

  /// Factory constructor to get an [AppSpacing] instance.
  ///
  /// Detects the current breakpoint and RTL direction from the [context].
  factory AppSpacing.of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final breakpoint = BreakpointCache.detect(size); // Uses the local Breakpoint enum and cache
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return AppSpacing._(breakpoint, isRTL, size);
  }

  // Pre-calculated spacing scales (compile-time constants)
  // These should ideally match or be derived from SpacingConstants in spacing_utils.dart
  // if a unified system is desired.
  // Indices correspond to Breakpoint.index.

  /// Base spacing values for each breakpoint.
  static const _baseValues = [4.0, 4.6, 5.2, 6.0, 6.8, 7.6, 8.0, 8.0]; // phoneSmall to desktop
  /// Margin multipliers for each breakpoint.
  static const _marginMultipliers = [4.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0];

  /// Gutter multipliers for each breakpoint.
  static const _gutterMultipliers = [2.0, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0];

  /// The base spacing unit for the current breakpoint.
  double get base => _baseValues[breakpoint.index];

  /// The standard margin for the current breakpoint (`base * multiplier`).
  double get margin => base * _marginMultipliers[breakpoint.index];

  /// The standard gutter spacing for the current breakpoint (`base * multiplier`).
  double get gutter => base * _gutterMultipliers[breakpoint.index];

  // Semantic spacing (multiples of base for consistency)

  /// Extra small spacing: `base * 0.5`.
  double get xs => base * 0.5;

  /// Small spacing: `base`.
  double get sm => base;

  /// Medium spacing: `base * 2`.
  double get md => base * 2;

  /// Large spacing: `base * 3`.
  double get lg => base * 3;

  /// Extra large spacing: `base * 4`.
  double get xl => base * 4;

  /// Extra-extra large spacing: `base * 6`.
  double get xxl => base * 6;

  /// Extra-extra-extra large spacing: `base * 8`.
  double get xxxl => base * 8;

  // Quick device type checks based on the current Breakpoint.

  /// True if the current breakpoint is a phone.
  bool get isMobile => breakpoint.isPhone;

  /// True if the current breakpoint is a tablet.
  bool get isTablet => breakpoint.isTablet;

  /// True if the current breakpoint is desktop.
  bool get isDesktop => breakpoint.isDesktop;

  /// True if the device is in landscape orientation.
  bool get isLandscape => screenSize.width > screenSize.height;

  /// Standard page padding: horizontal margin, vertical `base * 2` (i.e., `md`).
  EdgeInsetsGeometry get pagePadding => EdgeInsets.symmetric(
        horizontal: margin,
        vertical: base * 2, // md
      );

  /// Standard card padding: `md` for mobile, `lg` for larger screens (tablet/desktop).
  EdgeInsetsGeometry get cardPadding => EdgeInsets.all(isMobile ? md : lg);

  /// Standard input field padding: horizontal `md`, vertical `sm` (mobile) or `md` (larger).
  EdgeInsetsGeometry get inputPadding => EdgeInsets.symmetric(
        horizontal: md,
        vertical: isMobile ? sm : md,
      );

  /// Creates [EdgeInsetsDirectional] with specified start, end, top, and bottom values.
  /// Useful for RTL-aware padding.
  EdgeInsetsDirectional directionalPadding({
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

  /// Selects a value based on the current device type (phone, tablet, desktop).
  ///
  /// - [phone]: Value for phone breakpoints.
  /// - [tablet]: Value for tablet breakpoints.
  /// - [desktop]: Value for desktop breakpoints.
  /// - [fallback]: Value to use if the specific type is not matched or its value is null.
  T responsive<T>({
    T? phone,
    T? tablet,
    T? desktop,
    required T fallback,
  }) {
    if (breakpoint.isDesktop && desktop != null) return desktop;
    if (breakpoint.isTablet && tablet != null) return tablet;
    if (breakpoint.isPhone && phone != null) return phone;
    return fallback;
  }
}

/// A lightweight responsive layout builder that selects a builder function
/// based on the current [Breakpoint] (phone, tablet, desktop).
///
/// It provides the chosen builder with the [BuildContext] and an [AppSpacing] instance.
class ResponsiveBuilder extends StatelessWidget {
  /// Creates a ResponsiveBuilder.
  ///
  /// - [phone]: Builder for phone breakpoints.
  /// - [tablet]: Builder for tablet breakpoints.
  /// - [desktop]: Builder for desktop breakpoints.
  /// - [builder]: Default builder if no specific breakpoint builder matches or is provided.
  const ResponsiveBuilder({
    super.key,
    this.phone,
    this.tablet,
    this.desktop,
    required this.builder,
  });

  /// Builder function for phone breakpoints.
  final Widget Function(BuildContext, AppSpacing)? phone;

  /// Builder function for tablet breakpoints.
  final Widget Function(BuildContext, AppSpacing)? tablet;

  /// Builder function for desktop breakpoints.
  final Widget Function(BuildContext, AppSpacing)? desktop;

  /// Default builder function if no specific breakpoint builder is matched.
  final Widget Function(BuildContext, AppSpacing) builder;

  @override
  Widget build(BuildContext context) {
    final spacing = AppSpacing.of(context);
    final currentBp = spacing.breakpoint; // Use the breakpoint from AppSpacing

    if (currentBp.isDesktop && desktop != null) {
      return desktop!(context, spacing);
    }
    if (currentBp.isTablet && tablet != null) {
      return tablet!(context, spacing);
    }
    if (currentBp.isPhone && phone != null) {
      return phone!(context, spacing);
    }

    return builder(context, spacing);
  }
}

/// An optimized responsive grid that arranges children in a [Wrap].
///
/// Column count defaults to `appSpacing.breakpoint.gridColumns(appSpacing.isLandscape)`.
/// Spacing defaults to `appSpacing.gutter`.
class ResponsiveGrid extends StatelessWidget {
  /// Creates a ResponsiveGrid.
  ///
  /// - [children]: The list of widgets to display in the grid.
  /// - [spacing]: Horizontal and vertical spacing between items. Defaults to `appSpacing.gutter`.
  ///   If you need different runSpacing, consider using `Wrap` directly or enhancing this widget.
  /// - [columns]: The number of columns. Defaults based on breakpoint and orientation.
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.spacing,
    this.columns,
  });

  /// The widgets to lay out in the grid.
  final List<Widget> children;

  /// The spacing applied both horizontally between items and vertically between runs.
  /// Defaults to `appSpacing.gutter`.
  final double? spacing;

  /// The number of columns for the grid.
  /// Defaults to `appSpacing.breakpoint.gridColumns(appSpacing.isLandscape)`.
  final int? columns;

  @override
  Widget build(BuildContext context) {
    final appSpacing = AppSpacing.of(context);
    final gridSpacing = spacing ?? appSpacing.gutter;
    // By default, ResponsiveGrid uses the same spacing for main and cross axis.
    final gridRunSpacing = spacing ?? appSpacing.gutter;
    final gridColumns = columns ?? appSpacing.breakpoint.gridColumns(appSpacing.isLandscape);

    return _OptimizedWrap(
      spacing: gridSpacing,
      runSpacing: gridRunSpacing, // Use the same for runSpacing
      children: children,
      columns: gridColumns,
      isRTL: appSpacing.isRTL,
    );
  }
}

/// An internal widget that optimizes [Wrap] for grid layouts by calculating item widths.
///
/// It takes a fixed [columns] count and distributes the available width.
class _OptimizedWrap extends StatelessWidget {
  /// Creates an _OptimizedWrap.
  ///
  /// - [children]: List of widgets.
  /// - [spacing]: Horizontal spacing between items.
  /// - [runSpacing]: Vertical spacing between rows.
  /// - [columns]: Number of columns.
  /// - [isRTL]: Whether the layout is Right-to-Left.
  const _OptimizedWrap({
    required this.children,
    required this.spacing,
    required this.runSpacing,
    required this.columns,
    required this.isRTL,
  });

  final List<Widget> children;
  final double spacing;
  final double runSpacing;
  final int columns;
  final bool isRTL;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (columns <= 0) return const SizedBox.shrink(); // Avoid division by zero or negative columns

        final itemWidth = (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        // Ensure itemWidth is valid before creating SizedBoxes
        if (itemWidth <= 0 || !itemWidth.isFinite) {
          // If itemWidth is not positive, Wrap might behave unexpectedly or throw errors.
          // Fallback to letting Wrap manage items without explicit width, or render nothing.
          // For simplicity, let's render them without SizedBox wrapper if width is invalid.
          // This might not be ideal for all cases.
          return Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: children,
          );
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          children: children
              .map((child) => SizedBox(
                    width: itemWidth,
                    child: child,
                  ))
              .toList(),
        );
      },
    );
  }
}

/// A class that provides a responsive value based on the current [Breakpoint].
///
/// Use its `call(BuildContext context)` method to get the appropriate value.
/// This allows defining responsive values declaratively and resolving them at build time.
class ResponsiveValue<T> {
  /// Creates a ResponsiveValue holder.
  ///
  /// - [phone]: Value for phone breakpoints.
  /// - [tablet]: Value for tablet breakpoints.
  /// - [desktop]: Value for desktop breakpoints.
  /// - [fallback]: Value to use if no specific breakpoint matches or its value is null.
  const ResponsiveValue({
    this.phone,
    this.tablet,
    this.desktop,
    required this.fallback,
  });

  final T? phone;
  final T? tablet;
  final T? desktop;
  final T fallback;

  /// Resolves and returns the value `T` appropriate for the current breakpoint
  /// obtained from [context].
  ///
  /// Order of preference: desktop, tablet, phone, then fallback.
  T call(BuildContext context) {
    final bp = currentBreakpoint(context); // Uses the Breakpoint enum defined in this file

    if (bp.isDesktop && desktop != null) return desktop!;
    if (bp.isTablet && tablet != null) return tablet!;
    if (bp.isPhone && phone != null) return phone!;

    return fallback;
  }
}

/// Extension on [BuildContext] to provide easy access to the current [Breakpoint].
extension BreakpointContext on BuildContext {
  /// Gets the current [Breakpoint] using [currentBreakpoint(this)].
  Breakpoint get breakpoint => currentBreakpoint(this);

  /// Provides access to [AppSpacing] via `context.appSpacing`.
  /// Note: This could potentially conflict if `context.spacing` from `spacing_utils.dart` is also used.
  /// It's generally better to pick one spacing system or ensure clear namespacing.
  /// For this example, I am adding it as per the file's structure.
  AppSpacing get appSpacing => AppSpacing.of(this);

  /// Convenience getter for `context.appSpacing.isMobile`.
  bool get isMobile => appSpacing.isMobile;

  /// Convenience getter for `context.appSpacing.isTablet`.
  bool get isTablet => appSpacing.isTablet;

  /// Convenience getter for `context.appSpacing.isDesktop`.
  bool get isDesktop => appSpacing.isDesktop;

  /// Convenience getter for `context.appSpacing.isRTL`.
  bool get isRTL => appSpacing.isRTL;
}

/// A responsive container that applies a maximum width and padding.
///
/// Max width defaults to 1200 on desktop, and `double.infinity` otherwise.
/// Padding defaults to `context.appSpacing.pagePadding`.
///
/// **Note:** This widget is similar to `ResponsiveBox` from `spacing_utils.dart`.
/// Consider which one to use or how to consolidate if both files are in the same project.
/// This version uses `appSpacing` (from `breakpoints.dart`) whereas `ResponsiveBox` uses
/// `spacing` (from `spacing_utils.dart`).
class ResponsiveContainer extends StatelessWidget {
  /// Creates a ResponsiveContainer.
  ///
  /// - [child]: The content of the container.
  /// - [maxWidth]: Custom maximum width. Defaults based on device type.
  /// - [padding]: Custom padding. Defaults to `context.appSpacing.pagePadding`.
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth,
    this.padding,
  });

  final Widget child;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // Using appSpacing from BreakpointContext extension
    final spacing = context.appSpacing;

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? (spacing.isDesktop ? 1200 : double.infinity),
      ),
      padding: padding ?? spacing.pagePadding, // Uses AppSpacing's pagePadding
      child: child,
    );
  }
}

/// A widget that provides a responsive gap (empty space) based on semantic sizes
/// from [AppSpacing].
///
/// Similar to [Gap] from `spacing_utils.dart`, but uses [AppSpacing] and has a
/// slightly different set of predefined named constructors.
class ResponsiveGap extends StatelessWidget {
  /// Creates a responsive gap of a specific semantic size.
  const ResponsiveGap(this.size, {super.key});

  /// Creates a gap with `xs` (extra small) spacing from [AppSpacing].
  const ResponsiveGap.xs({super.key}) : size = _GapSize.xs;

  /// Creates a gap with `sm` (small) spacing from [AppSpacing].
  const ResponsiveGap.sm({super.key}) : size = _GapSize.sm;

  /// Creates a gap with `md` (medium) spacing from [AppSpacing].
  const ResponsiveGap.md({super.key}) : size = _GapSize.md;

  /// Creates a gap with `lg` (large) spacing from [AppSpacing].
  const ResponsiveGap.lg({super.key}) : size = _GapSize.lg;

  /// Creates a gap with `xl` (extra large) spacing from [AppSpacing].
  const ResponsiveGap.xl({super.key}) : size = _GapSize.xl;

  /// The semantic size of the gap.
  final _GapSize size; // This refers to the _GapSize enum below

  @override
  Widget build(BuildContext context) {
    final spacing = context.appSpacing; // Uses AppSpacing from BreakpointContext
    final value = switch (size) {
      _GapSize.xs => spacing.xs,
      _GapSize.sm => spacing.sm,
      _GapSize.md => spacing.md,
      _GapSize.lg => spacing.lg,
      _GapSize.xl => spacing.xl,
      // If _GapSize had more values, they'd need to be mapped here.
    };

    return SizedBox(width: value, height: value); // Creates a square gap
  }
}

/// Enum representing semantic gap sizes for the [ResponsiveGap] widget in this file.
/// Note: This is a distinct enum from the `_GapSize` in `spacing_utils.dart`.
enum _GapSize { xs, sm, md, lg, xl }

/// A widget that positions its child using directional (start/end) coordinates,
/// making it RTL-aware. It's a wrapper around [PositionedDirectional].
class ResponsivePositioned extends StatelessWidget {
  /// Creates an RTL-aware positioned widget.
  ///
  /// - [child]: The widget to position.
  /// - [start]: Distance from the start edge (left in LTR, right in RTL).
  /// - [end]: Distance from the end edge (right in LTR, left in RTL).
  /// - [top]: Distance from the top edge.
  /// - [bottom]: Distance from the bottom edge.
  const ResponsivePositioned({
    super.key,
    required this.child,
    this.start,
    this.end,
    this.top,
    this.bottom,
  });

  final Widget child;
  final double? start;
  final double? end;
  final double? top;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: start,
      end: end,
      top: top,
      bottom: bottom,
      child: child,
    );
  }
}
