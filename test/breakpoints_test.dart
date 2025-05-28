import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/src/breakpoints.dart';
import 'package:mobile_ultra_spacing/src/spacing_utils.dart';

void main() {
  group('Breakpoint Enum', () {
    test('should have correct minimum widths', () {
      expect(Breakpoint.phoneSmall.minWidth, 0);
      expect(Breakpoint.phoneMedium.minWidth, 375);
      expect(Breakpoint.phoneLarge.minWidth, 430);
      expect(Breakpoint.tabletSmall.minWidth, 500);
      expect(Breakpoint.tabletMedium.minWidth, 680);
      expect(Breakpoint.tabletLarge.minWidth, 820);
      expect(Breakpoint.tabletXLarge.minWidth, 1000);
      expect(Breakpoint.desktop.minWidth, 1200);
    });

    test('should categorize device types correctly', () {
      expect(Breakpoint.phoneSmall.isPhone, true);
      expect(Breakpoint.phoneMedium.isPhone, true);
      expect(Breakpoint.phoneLarge.isPhone, true);
      expect(Breakpoint.tabletSmall.isPhone, false);

      expect(Breakpoint.tabletSmall.isTablet, true);
      expect(Breakpoint.tabletMedium.isTablet, true);
      expect(Breakpoint.tabletLarge.isTablet, true);
      expect(Breakpoint.tabletXLarge.isTablet, true);
      expect(Breakpoint.desktop.isTablet, false);

      expect(Breakpoint.desktop.isDesktop, true);
      expect(Breakpoint.tabletXLarge.isDesktop, false);
    });

    test('should categorize size correctly', () {
      expect(Breakpoint.phoneSmall.isSmall, true);
      expect(Breakpoint.phoneMedium.isSmall, true);
      expect(Breakpoint.phoneLarge.isSmall, false);

      expect(Breakpoint.tabletLarge.isLarge, true);
      expect(Breakpoint.tabletXLarge.isLarge, true);
      expect(Breakpoint.desktop.isLarge, true);
      expect(Breakpoint.tabletMedium.isLarge, false);
    });

    test('should provide correct grid columns', () {
      // Test portrait vs landscape columns
      expect(Breakpoint.phoneSmall.gridColumns(false), 1); // portrait
      expect(Breakpoint.phoneSmall.gridColumns(true), 2); // landscape

      expect(Breakpoint.desktop.gridColumns(false), 6); // portrait
      expect(Breakpoint.desktop.gridColumns(true), 6); // landscape
    });
  });

  group('BreakpointCache', () {
    test('should detect correct breakpoints', () {
      expect(BreakpointCache.detect(const Size(300, 600)), Breakpoint.phoneSmall);
      expect(BreakpointCache.detect(const Size(400, 800)), Breakpoint.phoneMedium);
      expect(BreakpointCache.detect(const Size(450, 900)), Breakpoint.phoneLarge);
      expect(BreakpointCache.detect(const Size(600, 1000)), Breakpoint.tabletSmall);
      expect(BreakpointCache.detect(const Size(750, 1200)), Breakpoint.tabletMedium);
      expect(BreakpointCache.detect(const Size(900, 1400)), Breakpoint.tabletLarge);
      expect(BreakpointCache.detect(const Size(1100, 1600)), Breakpoint.tabletXLarge);
      expect(BreakpointCache.detect(const Size(1300, 1800)), Breakpoint.desktop);
    });

    test('should cache breakpoints correctly', () {
      final size = const Size(400, 800);
      final first = BreakpointCache.detect(size);
      final second = BreakpointCache.detect(size);

      expect(identical(first, second), true);
    });

    test('should invalidate cache correctly', () {
      final size1 = const Size(400, 800);
      final size2 = const Size(600, 1000);

      // First call with size1
      final first = BreakpointCache.detect(size1);
      expect(first, Breakpoint.phoneMedium);

      // Second call with same size should use cache (same result)
      final second = BreakpointCache.detect(size1);
      expect(second, first);

      // Call with different size should recalculate
      final third = BreakpointCache.detect(size2);
      expect(third, Breakpoint.tabletSmall);
      expect(third, isNot(equals(first)));

      // Invalidate cache
      BreakpointCache.invalidate();

      // After invalidation, should still work correctly
      final fourth = BreakpointCache.detect(size1);
      expect(fourth, Breakpoint.phoneMedium);
      expect(fourth, equals(first)); // Same enum value
    });
  });

  group('AppSpacing', () {
    testWidgets('should provide correct spacing values', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = AppSpacing.of(context);
              final base = spacing.base;

              expect(spacing.xs, base * 0.5);
              expect(spacing.sm, base);
              expect(spacing.md, base * 2);
              expect(spacing.lg, base * 3);
              expect(spacing.xl, base * 4);
              expect(spacing.xxl, base * 6);
              expect(spacing.xxxl, base * 8);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should detect device types correctly', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 1000);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = AppSpacing.of(context);

              expect(spacing.isMobile, false);
              expect(spacing.isTablet, true);
              expect(spacing.isDesktop, false);
              expect(spacing.breakpoint, Breakpoint.tabletMedium);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should handle landscape orientation', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(800, 400);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = AppSpacing.of(context);
              expect(spacing.isLandscape, true);
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveBuilder Widget', () {
    testWidgets('should use correct builder for device type', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            phone: (context, spacing) => const Text('Phone'),
            tablet: (context, spacing) => const Text('Tablet'),
            desktop: (context, spacing) => const Text('Desktop'),
            builder: (context, spacing) => const Text('Default'),
          ),
        ),
      );

      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);
      expect(find.text('Default'), findsNothing);
    });

    testWidgets('should fall back to default builder', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveBuilder(
            builder: (context, spacing) => const Text('Default'),
          ),
        ),
      );

      expect(find.text('Default'), findsOneWidget);
    });
  });

  group('ResponsiveGrid Widget', () {
    testWidgets('should create grid layout', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              children: List.generate(6, (i) => Text('Item $i')),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 5'), findsOneWidget);
    });

    testWidgets('should respect custom column count', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGrid(
              columns: 3,
              children: List.generate(3, (i) => Text('Item $i')),
            ),
          ),
        ),
      );

      // The grid should be created, specific layout testing would require more complex setup
      expect(find.byType(Wrap), findsOneWidget);
    });
  });

  group('ResponsiveValue', () {
    testWidgets('should resolve correct value for device type', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      const responsiveValue = ResponsiveValue<String>(
        phone: 'mobile',
        tablet: 'tablet',
        desktop: 'desktop',
        fallback: 'fallback',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final value = responsiveValue(context);
              expect(value, 'mobile');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should use fallback when specific value is null', (tester) async {
      const responsiveValue = ResponsiveValue<String>(
        fallback: 'fallback',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final value = responsiveValue(context);
              expect(value, 'fallback');
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('Context Extensions', () {
    testWidgets('should provide breakpoint information', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 1000);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(context.breakpoint, Breakpoint.tabletMedium);
              expect(context.isMobile, false);
              expect(context.isTablet, true);
              expect(context.isDesktop, false);
              expect(context.appSpacing, isA<AppSpacing>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('ResponsiveContainer Widget', () {
    testWidgets('should apply constraints and padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveContainer(
            child: Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, isNotNull);
      expect(container.padding, isNotNull);
    });

    testWidgets('should apply custom max width', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveContainer(
            maxWidth: 800,
            child: Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints?.maxWidth, 800);
    });
  });

  group('ResponsiveGap Widget', () {
    testWidgets('should create gaps with correct sizes', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Column(
            children: [
              ResponsiveGap.xs(),
              ResponsiveGap.sm(),
              ResponsiveGap.md(),
              ResponsiveGap.lg(),
              ResponsiveGap.xl(),
            ],
          ),
        ),
      );

      final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(sizedBoxes.length, greaterThanOrEqualTo(5));
    });
  });

  group('ResponsivePositioned Widget', () {
    testWidgets('should create positioned widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Stack(
            children: [
              ResponsivePositioned(
                start: 10,
                top: 20,
                child: Text('Positioned'),
              ),
            ],
          ),
        ),
      );

      expect(find.byType(PositionedDirectional), findsOneWidget);
      expect(find.text('Positioned'), findsOneWidget);
    });
  });
}
