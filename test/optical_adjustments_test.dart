import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/src/optical_adjustments.dart';

void main() {
  group('OpticalAdjustments', () {
    group('adjustSpacing', () {
      test('should apply default factor of 1.0', () {
        const originalSpacing = 16.0;
        final adjusted = OpticalAdjustments.adjustSpacing(originalSpacing);
        expect(adjusted, originalSpacing);
      });

      test('should apply custom factor', () {
        const originalSpacing = 16.0;
        const factor = 1.2;
        final adjusted = OpticalAdjustments.adjustSpacing(originalSpacing, factor: factor);
        expect(adjusted, originalSpacing * factor);
      });
    });

    group('asymmetricListPadding', () {
      testWidgets('should create asymmetric padding for LTR', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.asymmetricListPadding(
                  context: context,
                  baseHorizontal: 16.0,
                );

                expect(padding.left, 16.0 * 1.1); // leadingFactor
                expect(padding.right, 16.0 * 0.9); // trailingFactor
                expect(padding.top, 0);
                expect(padding.bottom, 0);

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should create asymmetric padding for RTL', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (context) {
                  final padding = OpticalAdjustments.asymmetricListPadding(
                    context: context,
                    baseHorizontal: 16.0,
                  );

                  expect(padding.left, 16.0 * 0.9); // trailingFactor in RTL
                  expect(padding.right, 16.0 * 1.1); // leadingFactor in RTL

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('should apply custom factors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.asymmetricListPadding(
                  context: context,
                  baseHorizontal: 20.0,
                  leadingFactor: 1.5,
                  trailingFactor: 0.5,
                );

                expect(padding.left, 20.0 * 1.5);
                expect(padding.right, 20.0 * 0.5);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('horizontalPadding', () {
      test('should create symmetric horizontal padding', () {
        final padding = OpticalAdjustments.horizontalPadding(12.0);
        expect(padding.left, 12.0);
        expect(padding.right, 12.0);
        expect(padding.top, 0);
        expect(padding.bottom, 0);
      });
    });

    group('verticalPadding', () {
      test('should create symmetric vertical padding', () {
        final padding = OpticalAdjustments.verticalPadding(8.0);
        expect(padding.left, 0);
        expect(padding.right, 0);
        expect(padding.top, 8.0);
        expect(padding.bottom, 8.0);
      });
    });

    group('adjustFontSize', () {
      test('should apply default adjustment', () {
        const calculatedSize = 16.0;
        final adjusted = OpticalAdjustments.adjustFontSize(calculatedSize);
        expect(adjusted, calculatedSize - 0.5);
      });

      test('should apply custom adjustment', () {
        const calculatedSize = 18.0;
        const adjustment = -1.0;
        final adjusted = OpticalAdjustments.adjustFontSize(calculatedSize, adjustment: adjustment);
        expect(adjusted, calculatedSize + adjustment);
      });

      test('should apply Arabic adjustment', () {
        const calculatedSize = 16.0;
        final adjusted = OpticalAdjustments.adjustFontSize(calculatedSize, isArabic: true);
        expect(adjusted, calculatedSize - 0.5 + 0.5); // Default adjustment + Arabic adjustment
      });

      test('should combine custom and Arabic adjustments', () {
        const calculatedSize = 20.0;
        const customAdjustment = -2.0;
        final adjusted = OpticalAdjustments.adjustFontSize(
          calculatedSize,
          adjustment: customAdjustment,
          isArabic: true,
        );
        expect(adjusted, calculatedSize + customAdjustment + 0.5);
      });
    });

    group('subtleShadow', () {
      test('should create shadow with default parameters', () {
        final shadows = OpticalAdjustments.subtleShadow();
        expect(shadows.length, 1);

        final shadow = shadows.first;
        // Use more lenient tolerance since Colors.black.withOpacity() may have slight precision differences
        expect(shadow.color.opacity, closeTo(0.03, 0.02));
        expect(shadow.blurRadius, 8.0);
        expect(shadow.spreadRadius, 0.5);
        expect(shadow.offset, const Offset(0, 1.0));
      });

      test('should scale with elevation', () {
        final shadows = OpticalAdjustments.subtleShadow(elevation: 2.0);
        expect(shadows.length, 1);

        final shadow = shadows.first;
        expect(shadow.color.opacity, closeTo(0.06, 0.02)); // 0.03 * 2.0, with lenient tolerance
        expect(shadow.blurRadius, 16.0); // 8.0 * 2.0
        expect(shadow.spreadRadius, 1.0); // 0.5 * 2.0
        expect(shadow.offset, const Offset(0, 2.0)); // 1.0 * 2.0
      });

      test('should use custom color', () {
        final shadows = OpticalAdjustments.subtleShadow(color: Colors.red);
        final shadow = shadows.first;
        // Test that the color is red with approximately the right opacity
        expect(shadow.color.red, Colors.red.red);
        expect(shadow.color.green, Colors.red.green);
        expect(shadow.color.blue, Colors.red.blue);
        expect(shadow.color.opacity, closeTo(0.03, 0.02));
      });
    });

    group('adjustBorderRadius', () {
      test('should reduce radius for small elements', () {
        final adjusted = OpticalAdjustments.adjustBorderRadius(8.0, 80);
        expect(adjusted, 8.0 * 0.9);
      });

      test('should increase radius for large elements', () {
        final adjusted = OpticalAdjustments.adjustBorderRadius(8.0, 320);
        expect(adjusted, 8.0 * 1.1);
      });

      test('should keep radius unchanged for medium elements', () {
        final adjusted = OpticalAdjustments.adjustBorderRadius(8.0, 200);
        expect(adjusted, 8.0);
      });

      test('should handle edge cases', () {
        expect(OpticalAdjustments.adjustBorderRadius(10.0, 100), 10.0);
        expect(OpticalAdjustments.adjustBorderRadius(10.0, 99), 10.0 * 0.9);
        expect(OpticalAdjustments.adjustBorderRadius(10.0, 300), 10.0);
        expect(OpticalAdjustments.adjustBorderRadius(10.0, 301), 10.0 * 1.1);
      });
    });

    group('adjustedTextStyle', () {
      test('should create text style with default adjustments', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        );

        expect(style.fontSize, 16.0);
        expect(style.fontWeight, FontWeight.w400);
        expect(style.height, 1.25); // fontSize >= 16, so 1.25
        expect(style.letterSpacing, 0.0); // fontSize between 14 and 18
      });

      test('should adjust for small text', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        );

        expect(style.height, 1.3); // fontSize < 16, so 1.3
        expect(style.letterSpacing, 0.25); // fontSize < 14, so 0.25
      });

      test('should adjust for large text (headings)', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.w600,
        );

        expect(style.height, 1.25); // fontSize >= 16, so 1.25
        expect(style.letterSpacing, -0.5); // fontSize > 18, so -0.5
      });

      test('should handle Arabic text correctly', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          isArabic: true,
        );

        expect(style.height, 1.4); // Arabic, fontSize >= 16, so 1.4
        expect(style.letterSpacing, 0.0); // Arabic always gets 0.0
        expect(style.fontWeight, FontWeight.w400);
      });

      test('should adjust Arabic font weights correctly', () {
        final lightStyle = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w200,
          isArabic: true,
        );
        expect(lightStyle.fontWeight, FontWeight.w300);

        final boldStyle = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
          isArabic: true,
        );
        expect(boldStyle.fontWeight, FontWeight.w700);

        final extraBoldStyle = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w900,
          isArabic: true,
        );
        expect(extraBoldStyle.fontWeight, FontWeight.w800);
      });

      test('should apply custom factors', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          heightFactor: 1.5,
          letterSpacingFactor: 2.0,
        );

        expect(style.height, 1.5);
        expect(style.letterSpacing, 16.0 * 2.0 / 100); // fontSize * factor / 100
      });

      test('should include color when provided', () {
        final style = OpticalAdjustments.adjustedTextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.blue,
        );

        expect(style.color, Colors.blue);
      });
    });

    group('directionalPadding', () {
      testWidgets('should create LTR directional padding', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.directionalPadding(
                  context: context,
                  start: 12.0,
                  end: 8.0,
                  top: 4.0,
                  bottom: 6.0,
                );

                // In LTR: start = left, end = right
                expect(padding.left, 12.0);
                expect(padding.right, 8.0);
                expect(padding.top, 4.0);
                expect(padding.bottom, 6.0);

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should create RTL directional padding', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (context) {
                  final padding = OpticalAdjustments.directionalPadding(
                    context: context,
                    start: 12.0,
                    end: 8.0,
                    top: 4.0,
                    bottom: 6.0,
                  );

                  // In RTL: start = right, end = left
                  expect(padding.left, 8.0);
                  expect(padding.right, 12.0);
                  expect(padding.top, 4.0);
                  expect(padding.bottom, 6.0);

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('should use default values for top and bottom', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.directionalPadding(
                  context: context,
                  start: 10.0,
                  end: 5.0,
                );

                expect(padding.top, 0.0);
                expect(padding.bottom, 0.0);

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('balancedContainerPadding', () {
      testWidgets('should create balanced padding with default factors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.balancedContainerPadding(
                  context: context,
                  base: 16.0,
                );

                expect(padding.left, 16.0); // leadingFactor: 1.0
                expect(padding.right, 16.0); // trailingFactor: 1.0
                expect(padding.top, 16.0); // topFactor: 1.0
                expect(padding.bottom, 16.0); // bottomFactor: 1.0

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should apply custom factors', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final padding = OpticalAdjustments.balancedContainerPadding(
                  context: context,
                  base: 10.0,
                  topFactor: 1.5,
                  bottomFactor: 1.2,
                  leadingFactor: 1.3,
                  trailingFactor: 0.8,
                );

                expect(padding.left, 10.0 * 1.3); // leading in LTR
                expect(padding.right, 10.0 * 0.8); // trailing in LTR
                expect(padding.top, 10.0 * 1.5);
                expect(padding.bottom, 10.0 * 1.2);

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should handle RTL direction', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (context) {
                  final padding = OpticalAdjustments.balancedContainerPadding(
                    context: context,
                    base: 12.0,
                    leadingFactor: 1.4,
                    trailingFactor: 0.6,
                  );

                  expect(padding.left, 12.0 * 0.6); // trailing in RTL
                  expect(padding.right, 12.0 * 1.4); // leading in RTL

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });

      testWidgets('should override context direction when isArabic is specified', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                // Context is LTR, but we override with isArabic: true (RTL)
                final padding = OpticalAdjustments.balancedContainerPadding(
                  context: context,
                  base: 15.0,
                  leadingFactor: 2.0,
                  trailingFactor: 0.5,
                  isArabic: true,
                );

                expect(padding.left, 15.0 * 0.5); // trailing in RTL
                expect(padding.right, 15.0 * 2.0); // leading in RTL

                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    group('listItemMargin', () {
      testWidgets('should create correct margins for first item', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final margin = OpticalAdjustments.listItemMargin(
                  context: context,
                  horizontal: 16.0,
                  vertical: 12.0,
                  isFirst: true,
                  isLast: false,
                );

                expect(margin.left, 16.0);
                expect(margin.right, 16.0);
                expect(margin.top, 12.0); // Full vertical margin for first
                expect(margin.bottom, 6.0); // Half vertical margin

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should create correct margins for last item', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final margin = OpticalAdjustments.listItemMargin(
                  context: context,
                  horizontal: 16.0,
                  vertical: 12.0,
                  isFirst: false,
                  isLast: true,
                );

                expect(margin.top, 6.0); // Half vertical margin
                expect(margin.bottom, 12.0); // Full vertical margin for last

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should create correct margins for middle item', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final margin = OpticalAdjustments.listItemMargin(
                  context: context,
                  horizontal: 16.0,
                  vertical: 12.0,
                  isFirst: false,
                  isLast: false,
                );

                expect(margin.top, 6.0); // Half vertical margin
                expect(margin.bottom, 6.0); // Half vertical margin

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should use specific leading and trailing values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final margin = OpticalAdjustments.listItemMargin(
                  context: context,
                  vertical: 8.0,
                  leading: 20.0,
                  trailing: 10.0,
                );

                expect(margin.left, 20.0); // leading in LTR
                expect(margin.right, 10.0); // trailing in LTR

                return const SizedBox();
              },
            ),
          ),
        );
      });

      testWidgets('should handle RTL with specific values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: Builder(
                builder: (context) {
                  final margin = OpticalAdjustments.listItemMargin(
                    context: context,
                    vertical: 8.0,
                    leading: 20.0,
                    trailing: 10.0,
                  );

                  expect(margin.left, 10.0); // trailing in RTL
                  expect(margin.right, 20.0); // leading in RTL

                  return const SizedBox();
                },
              ),
            ),
          ),
        );
      });
    });

    group('arabicLetterSpacing', () {
      test('should return zero for Arabic text', () {
        final spacing = OpticalAdjustments.arabicLetterSpacing(
          isArabic: true,
          defaultSpacing: 2.0,
        );
        expect(spacing, 0.0);
      });

      test('should return default spacing for non-Arabic text', () {
        final spacing = OpticalAdjustments.arabicLetterSpacing(
          isArabic: false,
          defaultSpacing: 1.5,
        );
        expect(spacing, 1.5);
      });

      test('should handle null default spacing', () {
        final spacing = OpticalAdjustments.arabicLetterSpacing(
          isArabic: false,
          defaultSpacing: null,
        );
        expect(spacing, null);
      });
    });

    group('determineFontWeight', () {
      test('should return desired weight for non-Arabic text', () {
        final weight = OpticalAdjustments.determineFontWeight(
          desiredWeight: FontWeight.w500,
          isArabic: false,
        );
        expect(weight, FontWeight.w500);
      });

      test('should increase contrast for non-Arabic when requested', () {
        final weight = OpticalAdjustments.determineFontWeight(
          desiredWeight: FontWeight.w300,
          isArabic: false,
          increasedContrast: true,
        );
        expect(weight, FontWeight.w600);
      });

      test('should not increase already bold weights', () {
        final weight = OpticalAdjustments.determineFontWeight(
          desiredWeight: FontWeight.w700,
          isArabic: false,
          increasedContrast: true,
        );
        expect(weight, FontWeight.w700);
      });

      test('should map Arabic weights correctly', () {
        expect(
          OpticalAdjustments.determineFontWeight(
            desiredWeight: FontWeight.w900,
            isArabic: true,
          ),
          FontWeight.w800,
        );

        expect(
          OpticalAdjustments.determineFontWeight(
            desiredWeight: FontWeight.w700,
            isArabic: true,
          ),
          FontWeight.w700,
        );

        expect(
          OpticalAdjustments.determineFontWeight(
            desiredWeight: FontWeight.w500,
            isArabic: true,
          ),
          FontWeight.w400,
        );

        expect(
          OpticalAdjustments.determineFontWeight(
            desiredWeight: FontWeight.w200,
            isArabic: true,
          ),
          FontWeight.w300,
        );
      });

      test('should prefer bolder weights for Arabic headings', () {
        final weight = OpticalAdjustments.determineFontWeight(
          desiredWeight: FontWeight.w500,
          isArabic: true,
          isHeading: true,
        );
        expect(weight, FontWeight.w700);
      });
    });

    group('adjustForRTL', () {
      test('should adjust RTL text style', () {
        const originalStyle = TextStyle(
          fontSize: 16.0,
          letterSpacing: 1.0,
          height: 1.2,
        );

        final adjustedStyle = OpticalAdjustments.adjustForRTL(originalStyle, true);

        expect(adjustedStyle.letterSpacing, 0.0);
        expect(adjustedStyle.height, closeTo(1.32, 0.01)); // 1.2 * 1.1
        expect(adjustedStyle.fontSize, 16.0); // Unchanged
      });

      test('should not adjust LTR text style', () {
        const originalStyle = TextStyle(
          fontSize: 16.0,
          letterSpacing: 1.0,
          height: 1.2,
        );

        final adjustedStyle = OpticalAdjustments.adjustForRTL(originalStyle, false);

        expect(adjustedStyle.letterSpacing, 1.0);
        expect(adjustedStyle.height, 1.2);
        expect(adjustedStyle.fontSize, 16.0);
      });

      test('should handle null height in original style', () {
        const originalStyle = TextStyle(
          fontSize: 16.0,
          letterSpacing: 1.0,
        );

        final adjustedStyle = OpticalAdjustments.adjustForRTL(originalStyle, true);

        expect(adjustedStyle.height, 1.3); // Default RTL height
      });
    });
  });
}
