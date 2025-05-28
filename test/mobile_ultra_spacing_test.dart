import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

void main() {
  group('SpacingConstants', () {
    test('should have correct number of breakpoints', () {
      expect(SpacingConstants.baseValues.length, 8);
      expect(SpacingConstants.marginScale.length, 8);
      expect(SpacingConstants.gutterScale.length, 8);
      expect(SpacingConstants.gridColumns.length, 8);
      expect(SpacingConstants.maxContentWidth.length, 8);
    });

    test('should have ascending base values', () {
      for (int i = 1; i < SpacingConstants.baseValues.length; i++) {
        expect(SpacingConstants.baseValues[i], greaterThanOrEqualTo(SpacingConstants.baseValues[i - 1]));
      }
    });

    test('should have valid grid columns', () {
      for (final columns in SpacingConstants.gridColumns) {
        expect(columns.length, 2); // portrait and landscape
        expect(columns[0], greaterThan(0)); // portrait columns > 0
        expect(columns[1], greaterThan(0)); // landscape columns > 0
        expect(columns[1], greaterThanOrEqualTo(columns[0])); // landscape >= portrait
      }
    });
  });

  group('OptimizedSpacing', () {
    testWidgets('should detect correct breakpoint for phone small', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(300, 600);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);
              expect(spacing.breakpointIndex, 0);
              expect(spacing.isMobile, true);
              expect(spacing.isTablet, false);
              expect(spacing.isDesktop, false);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should detect correct breakpoint for tablet', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 1000);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);
              expect(spacing.breakpointIndex, 4); // tabletMedium
              expect(spacing.isMobile, false);
              expect(spacing.isTablet, true);
              expect(spacing.isDesktop, false);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should detect correct breakpoint for desktop', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1400, 1300); // Both dimensions > 1200
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);
              expect(spacing.breakpointIndex, 7); // desktop
              expect(spacing.isMobile, false);
              expect(spacing.isTablet, false);
              expect(spacing.isDesktop, true);
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should cache spacing instance correctly', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      OptimizedSpacing? firstInstance;
      OptimizedSpacing? secondInstance;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              firstInstance = OptimizedSpacing.of(context);
              secondInstance = OptimizedSpacing.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(identical(firstInstance, secondInstance), true);
    });

    testWidgets('should provide correct semantic spacing values', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);
              final base = spacing.base;

              expect(spacing.micro, base * 0.25);
              expect(spacing.xs, base * 0.5);
              expect(spacing.sm, base);
              expect(spacing.md, base * 2);
              expect(spacing.lg, base * 3);
              expect(spacing.xl, base * 4);
              expect(spacing.xxl, base * 6);
              expect(spacing.xxxl, base * 8);
              expect(spacing.huge, base * 12);
              expect(spacing.massive, base * 16);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should handle RTL direction correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Builder(
              builder: (context) {
                final spacing = OptimizedSpacing.of(context);
                expect(spacing.isRTL, true);
                expect(spacing.startAlignment, Alignment.centerRight);
                expect(spacing.endAlignment, Alignment.centerLeft);
                expect(spacing.startText, TextAlign.right);
                expect(spacing.endText, TextAlign.left);
                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('should provide correct responsive values', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);

              final result = spacing.responsive<String>(
                phone: 'phone',
                tablet: 'tablet',
                desktop: 'desktop',
                fallback: 'fallback',
              );

              expect(result, 'phone');
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('Gap Widget', () {
    testWidgets('should render with correct dimensions', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                Gap.sm(),
                Gap.md(),
                Gap.lg(),
              ],
            ),
          ),
        ),
      );

      final gapWidgets = tester.widgetList<SizedBox>(find.byType(SizedBox));
      expect(gapWidgets.length, greaterThanOrEqualTo(3));
    });

    testWidgets('should create square gaps', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Gap.md(),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(sizedBox.height));
    });
  });

  group('ResponsiveBox Widget', () {
    testWidgets('should apply default padding and constraints', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveBox(
            child: Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.constraints, isNotNull);
      expect(container.padding, isNotNull);
    });

    testWidgets('should apply custom padding when provided', (tester) async {
      const customPadding = EdgeInsets.all(20);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveBox(
            padding: customPadding,
            child: Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, customPadding);
    });

    testWidgets('should center content when centerContent is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveBox(
            centerContent: true,
            child: Text('Test'),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.alignment, Alignment.center);
    });
  });

  group('ResponsiveSwitch Widget', () {
    testWidgets('should render phone content on mobile', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(350, 700);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveSwitch<Widget>(
            phone: const Text('Phone'),
            tablet: const Text('Tablet'),
            desktop: const Text('Desktop'),
            fallback: const Text('Fallback'),
          ),
        ),
      );

      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Tablet'), findsNothing);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should render tablet content on tablet', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 1000);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveSwitch<Widget>(
            phone: const Text('Phone'),
            tablet: const Text('Tablet'),
            desktop: const Text('Desktop'),
            fallback: const Text('Fallback'),
          ),
        ),
      );

      expect(find.text('Tablet'), findsOneWidget);
      expect(find.text('Phone'), findsNothing);
      expect(find.text('Desktop'), findsNothing);
    });

    testWidgets('should render fallback when specific content is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveSwitch<Widget>(
            phone: null,
            tablet: null,
            desktop: null,
            fallback: const Text('Fallback'),
          ),
        ),
      );

      expect(find.text('Fallback'), findsOneWidget);
    });

    testWidgets('should handle widget builder functions', (tester) async {
      // Set screen size to ensure phone breakpoint is detected
      tester.binding.window.physicalSizeTestValue = const Size(375, 667);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: ResponsiveSwitch<Widget Function()>(
            phone: () => const Text('Phone Builder'),
            fallback: () => const Text('Fallback Builder'),
          ),
        ),
      );

      expect(find.text('Phone Builder'), findsOneWidget);
      expect(find.text('Fallback Builder'), findsNothing);
    });
  });

  group('FastGrid Widget', () {
    testWidgets('should layout children in grid', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FastGrid(
              columns: 2,
              children: List.generate(4, (index) => Text('Item $index')),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsOneWidget);
      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
    });

    testWidgets('should respect RTL direction', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: FastGrid(
                columns: 2,
                children: List.generate(2, (index) => Text('Item $index')),
              ),
            ),
          ),
        ),
      );

      final wrap = tester.widget<Wrap>(find.byType(Wrap));
      expect(wrap.textDirection, TextDirection.rtl);
    });
  });

  group('Figma Integration', () {
    testWidgets('should convert common Figma values correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);

              expect(spacing.figma(8), spacing.sm);
              expect(spacing.figma(16), spacing.md);
              expect(spacing.figma(24), spacing.lg);
              expect(spacing.figma(32), spacing.xl);

              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('should scale Figma values based on breakpoint', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1400, 900);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spacing = OptimizedSpacing.of(context);
              final scaled = spacing.figmaScaled(16);
              final unscaled = spacing.figma(16);

              expect(scaled, greaterThan(unscaled));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('Utility Functions', () {
    testWidgets('responsive function should work correctly', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final result = responsive<String>(
                context,
                phone: 'mobile',
                tablet: 'tablet',
                desktop: 'desktop',
                fallback: 'fallback',
              );

              expect(result, 'mobile');
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('responsivePadding function should work correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final padding = responsivePadding(
                context,
                phone: const EdgeInsets.all(8),
                tablet: const EdgeInsets.all(16),
                desktop: const EdgeInsets.all(24),
                fallback: const EdgeInsets.all(12),
              );

              expect(padding, const EdgeInsets.all(8));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });

  group('Context Extensions', () {
    testWidgets('should provide correct device type checks', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 800);
      tester.binding.window.devicePixelRatioTestValue = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(context.isMobile, true);
              expect(context.isTablet, false);
              expect(context.isDesktop, false);
              expect(context.spacing, isA<OptimizedSpacing>());
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
