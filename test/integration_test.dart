import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

void main() {
  group('Integration Tests', () {
    testWidgets('should work together across different screen sizes', (tester) async {
      // Test phone size
      tester.binding.window.physicalSizeTestValue = const Size(375, 667);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveBox(
              child: Column(
                children: [
                  ResponsiveSwitch<Widget>(
                    phone: const Text('Phone Layout'),
                    tablet: const Text('Tablet Layout'),
                    desktop: const Text('Desktop Layout'),
                    fallback: const Text('Default Layout'),
                  ),
                  const Gap.md(),
                  FastGrid(
                    children: List.generate(4, (i) => Text('Grid Item $i')),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Phone Layout'), findsOneWidget);
      expect(find.text('Grid Item 0'), findsOneWidget);

      // Test tablet size
      tester.binding.window.physicalSizeTestValue = const Size(768, 1024);
      await tester.pumpAndSettle();

      expect(find.text('Tablet Layout'), findsOneWidget);
      expect(find.text('Phone Layout'), findsNothing);

      // Test desktop size - both dimensions must be >= 1200 for desktop breakpoint
      tester.binding.window.physicalSizeTestValue = const Size(1400, 1300);
      await tester.pumpAndSettle();

      expect(find.text('Desktop Layout'), findsOneWidget);
      expect(find.text('Tablet Layout'), findsNothing);
    });

    testWidgets('should handle RTL layout correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: Builder(
                builder: (context) {
                  final spacing = OptimizedSpacing.of(context);

                  return Container(
                    padding: spacing.directional(start: 16.0, end: 8.0),
                    child: Text(
                      'RTL Text',
                      textAlign: spacing.startText,
                      style: OpticalAdjustments.adjustedTextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        isArabic: true,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      expect(find.text('RTL Text'), findsOneWidget);

      final text = tester.widget<Text>(find.text('RTL Text'));
      expect(text.textAlign, TextAlign.right);
      expect(text.style?.letterSpacing, 0.0); // Arabic text
    });

    testWidgets('should apply optical adjustments correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: OpticalAdjustments.subtleShadow(),
                    borderRadius: BorderRadius.circular(
                      OpticalAdjustments.adjustBorderRadius(8.0, 100),
                    ),
                  ),
                  padding: OpticalAdjustments.balancedContainerPadding(
                    context: context,
                    base: 16.0,
                  ),
                  child: Text(
                    'Optically Adjusted',
                    style: OpticalAdjustments.adjustedTextStyle(
                      fontSize: OpticalAdjustments.adjustFontSize(18.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Optically Adjusted'), findsOneWidget);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.decoration, isA<BoxDecoration>());
      expect(container.padding, isNotNull);
    });

    testWidgets('should cache spacing instances for performance', (tester) async {
      OptimizedSpacing? firstCall;
      OptimizedSpacing? secondCall;
      OptimizedSpacing? thirdCall;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              firstCall = OptimizedSpacing.of(context);
              secondCall = OptimizedSpacing.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      // Same context should return identical instances
      expect(identical(firstCall, secondCall), true);

      // Clear cache and verify new instance is created
      OptimizedSpacing.clearCache();

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              thirdCall = OptimizedSpacing.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      // After cache clear, should get new instance
      expect(identical(firstCall, thirdCall), false);
      expect(firstCall?.breakpointIndex, thirdCall?.breakpointIndex);
    });

    testWidgets('should provide consistent responsive values', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacingValue = responsive<double>(
                context,
                phone: 8.0,
                tablet: 12.0,
                desktop: 16.0,
                fallback: 10.0,
              );

              final paddingValue = responsivePadding(
                context,
                phone: const EdgeInsets.all(8.0),
                tablet: const EdgeInsets.all(12.0),
                desktop: const EdgeInsets.all(16.0),
                fallback: const EdgeInsets.all(10.0),
              );

              // Values should be consistent
              expect(spacingValue, equals(paddingValue.left));

              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
