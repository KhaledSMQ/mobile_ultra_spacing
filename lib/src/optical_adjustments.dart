import 'package:flutter/material.dart';

/// A utility class that provides methods for making perceptual adjustments to UI elements.
///
/// ## The Principles of Optical Adjustments
///
/// Human visual perception doesn't always align with mathematical precision.
/// What looks "correct" to our eyes often differs from what is mathematically correct.
/// This class implements several established principles from graphic design and typography
/// to create visually balanced UI elements:
///
/// 1. **Optical Balance**: Elements that are mathematically equal may not appear visually equal.
///    For example, a perfect circle appears smaller than a perfect square of the same dimensions.
///
/// 2. **Visual Weight**: Different visual elements have different "weight" that affects how
///    they need to be spaced. For instance, text often needs more surrounding space than icons.
///
/// 3. **Perceptual Alignment**: The eye perceives alignment based on visual mass rather than
///    mathematical boundaries. Elements sometimes need to extend slightly beyond mathematical
///    boundaries to appear properly aligned.
///
/// 4. **Typography Adjustments**: Text has specific optical requirements for proper readability,
///    including line height (leading), letter spacing (tracking), and text size adjustments.
///
/// This class provides methods to apply these principles to Flutter UI elements,
/// creating interfaces that feel more natural and refined.
///
/// This implementation supports both LTR (Left-to-Right) and RTL (Right-to-Left) layouts.
class OpticalAdjustments {
  /// Applies slight optical adjustment to vertical spacing.
  ///
  /// This method slightly adjusts spacing to account for the way humans perceive
  /// vertical distances. Research shows we typically perceive vertical spaces as
  /// being slightly smaller than they actually are, requiring subtle adjustments
  /// for visual balance.
  ///
  /// The adjustment is particularly important for:
  /// - Creating proper breathing room around important elements
  /// - Establishing visual hierarchy through spacing
  /// - Maintaining visual rhythm in vertical layouts
  ///
  /// Example:
  /// ```dart
  /// // Adjust spacing to make headers feel properly separated from content
  /// final adjustedSpacing = OpticalAdjustments.adjustSpacing(24.0, factor: 1.08);
  /// return Column(
  ///   children: [
  ///     headerWidget,
  ///     SizedBox(height: adjustedSpacing),
  ///     contentWidget,
  ///   ],
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [originalSpacing]: The mathematical spacing to adjust
  ///   * [factor]: The adjustment factor (default: 1.0)
  ///
  /// Returns: The optically adjusted spacing value.
  static double adjustSpacing(double originalSpacing, {double factor = 1.0}) {
    // Optical adjustment factor - increase or decrease based on visual inspection
    return originalSpacing * factor;
  }

  /// Applies asymmetric padding for better visual flow in horizontal lists.
  ///
  /// This method creates padding that is visually balanced rather than mathematically equal.
  /// Studies in graphic design have shown that equal padding on both sides often appears
  /// unbalanced due to reading direction and visual scanning patterns.
  ///
  /// By default, this method:
  /// - Increases the leading padding slightly (by 10%) to create a stronger visual anchor
  /// - Decreases the trailing padding slightly (by 10%) to create visual flow
  ///
  /// The method automatically adjusts the padding based on the text direction (LTR or RTL).
  ///
  /// This adjustment is particularly effective for:
  /// - Horizontal scrolling lists
  /// - Content with a clear reading direction
  /// - Item containers that need to feel balanced
  ///
  /// Example:
  /// ```dart
  /// // Create a visually balanced horizontal list
  /// return ListView.builder(
  ///   scrollDirection: Axis.horizontal,
  ///   itemBuilder: (context, index) {
  ///     return Padding(
  ///       padding: OpticalAdjustments.asymmetricListPadding(
  ///         context: context,
  ///         baseHorizontal: 16.0
  ///       ),
  ///       child: listItem,
  ///     );
  ///   },
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [context]: The build context to determine text direction
  ///   * [baseHorizontal]: The base padding value to adjust
  ///   * [leadingFactor]: Multiplier for leading padding (default: 1.1)
  ///   * [trailingFactor]: Multiplier for trailing padding (default: 0.9)
  ///
  /// Returns: [EdgeInsets] with optically adjusted padding based on text direction.
  static EdgeInsets asymmetricListPadding(
      {required BuildContext context,
      required double baseHorizontal,
      double leadingFactor = 1.1,
      double trailingFactor = 0.9}) {
    final textDirection = Directionality.of(context);

    if (textDirection == TextDirection.ltr) {
      return EdgeInsets.only(left: baseHorizontal * leadingFactor, right: baseHorizontal * trailingFactor);
    } else {
      return EdgeInsets.only(left: baseHorizontal * trailingFactor, right: baseHorizontal * leadingFactor);
    }
  }

  /// Applies horizontal padding with an optical balance.
  ///
  /// Unlike asymmetric padding, this method creates symmetric horizontal padding
  /// that accounts for the container's visual weight. Proper horizontal padding
  /// creates visual breathing room between elements and container edges.
  ///
  /// This method is useful for:
  /// - Button paddings
  /// - Container paddings
  /// - List item paddings
  ///
  /// Example:
  /// ```dart
  /// return Container(
  ///   padding: OpticalAdjustments.horizontalPadding(16.0),
  ///   child: Text('Balanced Button'),
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [value]: The base padding value to apply
  ///
  /// Returns: [EdgeInsets] with horizontal padding.
  static EdgeInsets horizontalPadding(double value) {
    return EdgeInsets.symmetric(horizontal: value);
  }

  /// Applies vertical padding with an optical balance.
  ///
  /// This method creates symmetric vertical padding that is perceptually balanced.
  /// Proper vertical padding is essential for:
  /// - Button height
  /// - List item height
  /// - Vertical spacing between container elements
  ///
  /// Example:
  /// ```dart
  /// return Container(
  ///   padding: OpticalAdjustments.verticalPadding(12.0),
  ///   child: Text('Vertically Balanced Text'),
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [value]: The base padding value to apply
  ///
  /// Returns: [EdgeInsets] with vertical padding.
  static EdgeInsets verticalPadding(double value) {
    return EdgeInsets.symmetric(vertical: value);
  }

  /// Adjusts font size for better visual balance.
  ///
  /// Typography research shows that the mathematical size of a font doesn't always
  /// correlate with its perceived size. Different typefaces at the same point size
  /// can appear dramatically different in actual visual size.
  ///
  /// This method applies a small adjustment to font sizes to account for:
  /// - Font design differences (x-height variations)
  /// - Perceptual size differences between font weights
  /// - Variations in visual weight between different UI contexts
  ///
  /// By default, this applies a slight reduction (-0.5) which helps text
  /// feel less dominating in most UI contexts.
  ///
  /// Example:
  /// ```dart
  /// final calculatedSize = 16.0 * scaleFactor;
  /// final adjustedSize = OpticalAdjustments.adjustFontSize(calculatedSize);
  /// return Text(
  ///   'Optically balanced text',
  ///   style: TextStyle(fontSize: adjustedSize),
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [calculatedSize]: The mathematically calculated font size
  ///   * [adjustment]: The adjustment to apply (default: -0.5)
  ///   * [isArabic]: Whether the text is in Arabic script (default: false)
  ///
  /// Returns: The optically adjusted font size.
  static double adjustFontSize(double calculatedSize, {double adjustment = -0.5, bool isArabic = false}) {
    // Arabic fonts often need a slight increase to appear visually balanced
    // with Latin scripts, since Arabic characters tend to have a smaller
    // perceived size at the same mathematical size
    final arabicAdjustment = isArabic ? 0.5 : 0.0;
    return calculatedSize + adjustment + arabicAdjustment;
  }

  /// Creates optically balanced shadow for cards and elevated elements.
  ///
  /// This method generates shadows that feel natural by applying principles of light
  /// physics and how humans perceive elevation. Research in design systems shows that
  /// mathematically correct shadows often appear too harsh or too subtle.
  ///
  /// Key adjustments include:
  /// - Reduced opacity for a more subtle, natural appearance
  /// - Balanced blur radius that scales with elevation
  /// - Slight offset to simulate natural light direction
  ///
  /// The resulting shadows create a sense of elevation without being visually dominant.
  ///
  /// Example:
  /// ```dart
  /// return Container(
  ///   decoration: BoxDecoration(
  ///     color: Colors.white,
  ///     borderRadius: BorderRadius.circular(8),
  ///     boxShadow: OpticalAdjustments.subtleShadow(),
  ///   ),
  ///   child: content,
  /// );
  /// ```
  ///
  /// For higher elevation, increase the elevation parameter:
  /// ```dart
  /// boxShadow: OpticalAdjustments.subtleShadow(elevation: 3.0),
  /// ```
  ///
  /// Parameters:
  ///   * [color]: The shadow color (null uses black with adjusted opacity)
  ///   * [elevation]: The elevation level (default: 1.0)
  ///
  /// Returns: A list of [BoxShadow] objects creating the shadow effect.
  static List<BoxShadow> subtleShadow({Color? color, double elevation = 1.0}) {
    // Base opacity reduced for more subtle appearance
    final baseOpacity = 0.03 * elevation;

    return [
      BoxShadow(
          color: (color ?? Colors.black).withAlpha((baseOpacity * 255).round()),
          blurRadius: 8.0 * elevation,
          spreadRadius: 0.5 * elevation,
          offset: Offset(0, 1.0 * elevation))
    ];
  }

  /// Adjust border radius for better visual perception based on element size.
  ///
  /// This method applies the principle that the perceived curvature of a corner
  /// is affected by the overall size of the element. What looks "properly rounded"
  /// changes as elements scale.
  ///
  /// Specifically:
  /// - Smaller elements need proportionally smaller radii to appear balanced
  /// - Larger elements can support proportionally larger radii
  ///
  /// Example:
  /// ```dart
  /// // For a small button
  /// final smallButtonRadius = OpticalAdjustments.adjustBorderRadius(8.0, 80);
  ///
  /// // For a large card
  /// final largeCardRadius = OpticalAdjustments.adjustBorderRadius(8.0, 320);
  /// ```
  ///
  /// Parameters:
  ///   * [baseRadius]: The starting border radius value
  ///   * [elementSize]: The width or height of the element (use the smaller dimension)
  ///
  /// Returns: The optically adjusted border radius.
  static double adjustBorderRadius(double baseRadius, double elementSize) {
    // Scale radius down slightly for small elements, up for large ones
    if (elementSize < 100) {
      return baseRadius * 0.9; // Reduce radius slightly for small elements
    } else if (elementSize > 300) {
      return baseRadius * 1.1; // Increase radius slightly for large elements
    }
    return baseRadius;
  }

  /// Creates visually balanced text style with adjusted line height and letter spacing.
  ///
  /// This method applies typographic principles to create naturally balanced text:
  ///
  /// 1. **Line Height Adjustment**:
  ///    - Smaller text (< 16pt) needs proportionally more line height (130%)
  ///    - Larger text needs less line height (125%)
  ///    - This improves readability and visual rhythm
  ///
  /// 2. **Letter Spacing Adjustment**:
  ///    - Headings (larger text) benefit from tighter letter spacing (negative)
  ///    - Body text benefits from slightly looser spacing (positive)
  ///    - Small text needs more spacing for legibility
  ///
  /// 3. **Arabic Script Considerations**:
  ///    - Arabic script uses no letter spacing
  ///    - Arabic text benefits from slightly more line height
  ///    - Size perception is adjusted for Arabic characters
  ///
  /// These adjustments are based on established typography best practices
  /// and help text feel more professionally crafted.
  ///
  /// Example:
  /// ```dart
  /// // Create balanced heading text
  /// final headingStyle = OpticalAdjustments.adjustedTextStyle(
  ///   fontSize: 24.0,
  ///   fontWeight: FontWeight.bold,
  ///   color: Colors.black87,
  /// );
  ///
  /// // Create balanced Arabic heading text
  /// final arabicHeadingStyle = OpticalAdjustments.adjustedTextStyle(
  ///   fontSize: 24.0,
  ///   fontWeight: FontWeight.bold,
  ///   color: Colors.black87,
  ///   isArabic: true,
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [fontSize]: The font size in logical pixels
  ///   * [fontWeight]: The font weight
  ///   * [color]: The text color (optional)
  ///   * [heightFactor]: Custom line height factor (optional)
  ///   * [letterSpacingFactor]: Custom letter spacing factor (optional)
  ///   * [isArabic]: Whether the text is in Arabic script (default: false)
  ///
  /// Returns: A [TextStyle] with optical adjustments applied.
  static TextStyle adjustedTextStyle({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? heightFactor,
    double? letterSpacingFactor,
    bool isArabic = false,
  }) {
    // Calculate appropriate line height:
    // - Arabic script typically needs more vertical space
    // - Smaller text needs more line height for readability
    double actualHeight;
    if (heightFactor != null) {
      actualHeight = heightFactor;
    } else if (isArabic) {
      // Arabic needs more line height
      actualHeight = fontSize < 16 ? 1.5 : 1.4;
    } else {
      // Latin scripts
      actualHeight = fontSize < 16 ? 1.3 : 1.25;
    }

    // Calculate letter spacing:
    // - No letter spacing for Arabic (it can break text)
    // - Negative for headings, positive for body text in Latin scripts
    double? actualLetterSpacing;

    if (isArabic) {
      // Arabic script should have no letter spacing
      actualLetterSpacing = 0.0;
    } else if (letterSpacingFactor != null) {
      // Use the provided factor if specified
      actualLetterSpacing = fontSize * letterSpacingFactor / 100;
    } else {
      // Calculate based on font size for Latin scripts
      if (fontSize > 18) {
        // Headings benefit from tighter spacing
        actualLetterSpacing = -0.5;
      } else if (fontSize < 14) {
        // Small text needs more spacing for legibility
        actualLetterSpacing = 0.25;
      } else {
        // Middle range
        actualLetterSpacing = 0.0;
      }
    }

    // Adjust the font weight for Arabic based on available weights
    // in the Almarai font family (or other Arabic fonts)
    FontWeight adjustedWeight = fontWeight;
    if (isArabic) {
      if (fontWeight.index >= FontWeight.w800.index) {
        adjustedWeight = FontWeight.w800; // ExtraBold
      } else if (fontWeight.index >= FontWeight.w700.index) {
        adjustedWeight = FontWeight.w700; // Bold
      } else if (fontWeight.index >= FontWeight.w400.index) {
        adjustedWeight = FontWeight.w400; // Regular
      } else {
        adjustedWeight = FontWeight.w300; // Light
      }
    }

    return TextStyle(
      fontSize: fontSize,
      fontWeight: adjustedWeight,
      color: color,
      height: actualHeight,
      letterSpacing: actualLetterSpacing,
      // Appropriate text direction is handled at the widget level
    );
  }

  /// Applies directional-aware padding for various UI elements.
  ///
  /// This method creates padding that respects the text direction (RTL or LTR),
  /// making it useful for:
  /// - Icon buttons with text
  /// - Navigation items
  /// - Any element where padding should respect reading direction
  ///
  /// Example:
  /// ```dart
  /// // A button with an icon that respects text direction
  /// return Container(
  ///   padding: OpticalAdjustments.directionalPadding(
  ///     context: context,
  ///     start: 12.0,  // Padding at the start of reading direction
  ///     end: 16.0,    // Padding at the end of reading direction
  ///     top: 8.0,
  ///     bottom: 8.0,
  ///   ),
  ///   child: Row(
  ///     mainAxisSize: MainAxisSize.min,
  ///     children: [
  ///       Icon(Icons.arrow_back),
  ///       SizedBox(width: 8.0),
  ///       Text('Back'),
  ///     ],
  ///   ),
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [context]: The build context to determine text direction
  ///   * [start]: Padding at the start of reading direction
  ///   * [end]: Padding at the end of reading direction
  ///   * [top]: Padding at the top (default: 0.0)
  ///   * [bottom]: Padding at the bottom (default: 0.0)
  ///
  /// Returns: [EdgeInsets] with direction-aware padding.
  static EdgeInsets directionalPadding(
      {required BuildContext context,
      required double start,
      required double end,
      double top = 0.0,
      double bottom = 0.0}) {
    final textDirection = Directionality.of(context);

    return EdgeInsetsDirectional.fromSTEB(start, top, end, bottom).resolve(textDirection);
  }

  /// Applies balanced container padding with special consideration for RTL layouts.
  ///
  /// This method creates container padding that is visually balanced rather than
  /// mathematically equal. It applies specific adjustments for:
  /// - RTL layouts (like Arabic) which may need different optical adjustments
  /// - Different padding needs for top/bottom versus sides
  /// - Visual weight differences that may need compensation
  ///
  /// Use cases include:
  /// - Adjusting padding for reading direction (more leading padding in any layout)
  /// - Accounting for visual weight differences between top and bottom
  /// - Creating proper spacing when container contents have different visual density
  ///
  /// Example:
  /// ```dart
  /// // Create a card with balanced internal spacing
  /// return Container(
  ///   padding: OpticalAdjustments.balancedContainerPadding(
  ///     context: context,
  ///     base: 16.0,
  ///     topFactor: 1.25,    // More top padding
  ///     bottomFactor: 1.25, // More bottom padding
  ///     leadingFactor: 1.1, // More padding at the start of reading direction
  ///   ),
  ///   child: content,
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [context]: The build context to determine text direction
  ///   * [base]: The base padding value
  ///   * [topFactor]: Multiplier for top padding (default: 1.0)
  ///   * [bottomFactor]: Multiplier for bottom padding (default: 1.0)
  ///   * [leadingFactor]: Multiplier for leading (start) padding (default: 1.0)
  ///   * [trailingFactor]: Multiplier for trailing (end) padding (default: 1.0)
  ///   * [isArabic]: Whether the content is in Arabic (overrides context direction if true)
  ///
  /// Returns: [EdgeInsets] with optically balanced padding in all directions.
  static EdgeInsets balancedContainerPadding({
    required BuildContext context,
    required double base,
    double topFactor = 1.0,
    double bottomFactor = 1.0,
    double leadingFactor = 1.0,
    double trailingFactor = 1.0,
    bool? isArabic,
  }) {
    TextDirection textDirection;

    if (isArabic == true) {
      textDirection = TextDirection.rtl;
    } else if (isArabic == false) {
      textDirection = TextDirection.ltr;
    } else {
      textDirection = Directionality.of(context);
    }

    if (textDirection == TextDirection.ltr) {
      return EdgeInsets.fromLTRB(
        base * leadingFactor, // Left (leading in LTR)
        base * topFactor, // Top
        base * trailingFactor, // Right (trailing in LTR)
        base * bottomFactor, // Bottom
      );
    } else {
      return EdgeInsets.fromLTRB(
        base * trailingFactor, // Left (trailing in RTL)
        base * topFactor, // Top
        base * leadingFactor, // Right (leading in RTL)
        base * bottomFactor, // Bottom
      );
    }
  }

  /// Creates visually balanced margins for list items.
  ///
  /// This method applies special treatment to first and last items in a list,
  /// accounting for the perceptual principles that:
  /// - The first item needs full top margin to establish separation from what's above
  /// - The last item needs full bottom margin to establish separation from what's below
  /// - Middle items need only half margins since their margins combine with adjacent items
  ///
  /// This approach creates more consistent visual spacing while avoiding unnecessarily
  /// large gaps between items.
  ///
  /// Example:
  /// ```dart
  /// // In a ListView.builder:
  /// itemBuilder: (context, index) {
  ///   final isFirst = index == 0;
  ///   final isLast = index == totalItems - 1;
  ///
  ///   return Container(
  ///     margin: OpticalAdjustments.listItemMargin(
  ///       context: context,
  ///       horizontal: 16.0,
  ///       vertical: 12.0,
  ///       isFirst: isFirst,
  ///       isLast: isLast,
  ///     ),
  ///     child: listItem,
  ///   );
  /// }
  /// ```
  ///
  /// Parameters:
  ///   * [context]: The build context to determine text direction
  ///   * [horizontal]: The horizontal margin to apply, or use specific [leading] and [trailing]
  ///   * [vertical]: The base vertical margin
  ///   * [isFirst]: Whether this is the first item in the list
  ///   * [isLast]: Whether this is the last item in the list
  ///   * [leading]: Optional specific leading margin (overrides [horizontal] if provided)
  ///   * [trailing]: Optional specific trailing margin (overrides [horizontal] if provided)
  ///
  /// Returns: [EdgeInsets] with optically balanced list item margins.
  static EdgeInsets listItemMargin({
    required BuildContext context,
    double? horizontal,
    required double vertical,
    bool isFirst = false,
    bool isLast = false,
    double? leading,
    double? trailing,
  }) {
    assert(horizontal != null || (leading != null && trailing != null),
        'Either provide horizontal or both leading and trailing values');

    final textDirection = Directionality.of(context);
    final resolvedLeading = leading ?? horizontal!;
    final resolvedTrailing = trailing ?? horizontal!;

    if (textDirection == TextDirection.ltr) {
      return EdgeInsets.only(
          left: resolvedLeading,
          right: resolvedTrailing,
          top: isFirst ? vertical : vertical / 2,
          bottom: isLast ? vertical : vertical / 2);
    } else {
      return EdgeInsets.only(
          left: resolvedTrailing,
          right: resolvedLeading,
          top: isFirst ? vertical : vertical / 2,
          bottom: isLast ? vertical : vertical / 2);
    }
  }

  /// Adjusts letter spacing specifically for Arabic text.
  ///
  /// This method handles the special needs of Arabic typography:
  /// - Ensures zero letter spacing for Arabic
  /// - Maintains proper spacing for mixed text
  /// - Allows custom spacing for non-Arabic
  ///
  /// Example:
  /// ```dart
  /// return Text(
  ///   'مرحبا بالعالم',  // "Hello World" in Arabic
  ///   style: TextStyle(
  ///     fontSize: 18.0,
  ///     letterSpacing: OpticalAdjustments.arabicLetterSpacing(
  ///       isArabic: true,
  ///       defaultSpacing: 0.5,
  ///     ),
  ///   ),
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [isArabic]: Whether the text is in Arabic
  ///   * [defaultSpacing]: The spacing to use for non-Arabic text
  ///
  /// Returns: Appropriate letter spacing value.
  static double? arabicLetterSpacing({required bool isArabic, double? defaultSpacing}) {
    if (isArabic) {
      return 0.0; // Arabic text should have no letter spacing
    } else {
      return defaultSpacing; // Return the provided spacing for other scripts
    }
  }

  /// Determines the most appropriate font weight for different scenarios.
  ///
  /// This method accounts for:
  /// - Available weights in different font families
  /// - Different visual weight perception between scripts
  /// - The need for stronger contrast in some UI contexts
  ///
  /// Example:
  /// ```dart
  /// final weight = OpticalAdjustments.determineFontWeight(
  ///   desiredWeight: FontWeight.w600,
  ///   isArabic: true,
  ///   isHeading: true,
  /// );
  /// ```
  ///
  /// Parameters:
  ///   * [desiredWeight]: The ideal font weight
  ///   * [isArabic]: Whether using Arabic font family
  ///   * [isHeading]: Whether this is a heading (affects weight mapping)
  ///   * [increasedContrast]: Whether to increase contrast (for accessibility)
  ///
  /// Returns: The most appropriate [FontWeight].
  static FontWeight determineFontWeight(
      {required FontWeight desiredWeight,
      required bool isArabic,
      bool isHeading = false,
      bool increasedContrast = false}) {
    if (!isArabic) {
      // For Latin scripts, we can use the desired weight directly,
      // or adjust for contrast if needed
      if (increasedContrast) {
        if (desiredWeight.index < FontWeight.w600.index) {
          return FontWeight.w600; // Increase contrast by using bolder weight
        }
      }
      return desiredWeight;
    }

    // For Arabic (with Almarai font), map to available weights
    if (isArabic) {
      if (desiredWeight.index >= FontWeight.w800.index) {
        return FontWeight.w800; // ExtraBold
      } else if (desiredWeight.index >= FontWeight.w700.index) {
        return FontWeight.w700; // Bold
      } else if (desiredWeight.index >= FontWeight.w500.index) {
        // For headings, prefer slightly bolder
        return isHeading ? FontWeight.w700 : FontWeight.w400;
      } else if (desiredWeight.index >= FontWeight.w400.index) {
        return FontWeight.w400; // Regular
      } else {
        return FontWeight.w300; // Light
      }
    }

    // Default fallback
    return desiredWeight;
  }

  /// Adjust text for right-to-left languages like Arabic
  ///
  /// This method makes specific adjustments for RTL text:
  /// - Removes letter spacing (which can break Arabic ligatures)
  /// - Increases line height slightly for better readability
  /// - Ensures proper text alignment
  ///
  /// Example:
  /// ```dart
  /// final style = TextStyle(fontSize: 16.0);
  /// final rtlAdjustedStyle = OpticalAdjustments.adjustForRTL(style, isRTL: true);
  /// ```
  ///
  /// Parameters:
  ///   * [style]: The original text style
  ///   * [isRTL]: Whether the text is right-to-left
  ///
  /// Returns: An adjusted [TextStyle].
  static TextStyle adjustForRTL(TextStyle style, bool isRTL) {
    if (isRTL) {
      return style.copyWith(
        letterSpacing: 0.0, // No letter spacing for RTL languages
        height: style.height != null ? style.height! * 1.1 : 1.3, // Slightly more line height
      );
    }
    return style;
  }
}
