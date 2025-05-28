import 'package:flutter/material.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

void main() {
  runApp(const SpacingDemoApp());
}

class SpacingDemoApp extends StatelessWidget {
  const SpacingDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Spacing Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const DemoHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DemoHomePage extends StatefulWidget {
  const DemoHomePage({super.key});

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  int _selectedIndex = 0;

  final List<DemoSection> _sections = [
    DemoSection('Breakpoint Info', Icons.info, const BreakpointInfoDemo()),
    DemoSection('Spacing Values', Icons.space_bar, const SpacingValuesDemo()),
    DemoSection('Responsive Widgets', Icons.widgets, const ResponsiveWidgetsDemo()),
    DemoSection('Layout Examples', Icons.view_quilt, const LayoutExamplesDemo()),
    DemoSection('Optical Adjustments', Icons.visibility, const OpticalAdjustmentsDemo()),
    DemoSection('RTL Support', Icons.format_textdirection_r_to_l, const RTLDemo()),
    DemoSection('Performance Test', Icons.speed, const PerformanceTestDemo()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Spacing System Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: context.spacing.isMobile
          ? _MobileLayout(
              sections: _sections,
              selectedIndex: _selectedIndex,
              onSelectionChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              })
          : Row(
              children: [
                // Sidebar navigation for larger screens
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: _sections
                      .map((section) => NavigationRailDestination(
                            icon: Icon(section.icon),
                            label: Text(section.title),
                          ))
                      .toList(),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                // Main content
                Expanded(
                  child: _sections[_selectedIndex].widget,
                ),
              ],
            ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.sections,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });

  final List<DemoSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab bar for mobile
        Container(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sections.length,
            itemBuilder: (context, index) {
              final section = sections[index];
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => onSelectionChanged(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.spacing.md,
                    vertical: context.spacing.sm,
                  ),
                  margin: EdgeInsets.all(context.spacing.xs),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        section.icon,
                        color: isSelected ? Colors.white : Colors.grey,
                        size: 16,
                      ),
                      SizedBox(width: context.spacing.xs),
                      Text(
                        section.title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(height: 1),
        // Main content
        Expanded(
          child: sections[selectedIndex].widget,
        ),
      ],
    );
  }
}

class DemoSection {
  final String title;
  final IconData icon;
  final Widget widget;

  DemoSection(this.title, this.icon, this.widget);
}

// DEMO 1: Breakpoint Information
class BreakpointInfoDemo extends StatelessWidget {
  const BreakpointInfoDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ResponsiveBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Breakpoint Information',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap.lg(),

            // Current breakpoint card
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Breakpoint',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    _InfoRow('Index', '${spacing.breakpointIndex}'),
                    _InfoRow('Device Type', _getDeviceType(spacing)),
                    _InfoRow('Is Mobile', '${spacing.isMobile}'),
                    _InfoRow('Is Tablet', '${spacing.isTablet}'),
                    _InfoRow('Is Desktop', '${spacing.isDesktop}'),
                    _InfoRow('Is Landscape', '${spacing.isLandscape}'),
                    _InfoRow('Is RTL', '${spacing.isRTL}'),
                    _InfoRow('Screen Width', '${spacing.screenWidth.toInt()}px'),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Spacing values card
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spacing Values',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    _InfoRow('Base', '${spacing.base.toStringAsFixed(1)}dp'),
                    _InfoRow('Margin', '${spacing.margin.toStringAsFixed(1)}dp'),
                    _InfoRow('Gutter', '${spacing.gutter.toStringAsFixed(1)}dp'),
                    _InfoRow('Columns', '${spacing.columns}'),
                    _InfoRow(
                        'Max Content Width',
                        spacing.maxContentWidth == double.infinity
                            ? 'Unlimited'
                            : '${spacing.maxContentWidth.toInt()}px'),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Resize instruction
            Container(
              padding: spacing.cardPadding,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(
                      'Resize your window to see how breakpoints change in real-time!',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDeviceType(OptimizedSpacing spacing) {
    if (spacing.isDesktop) return 'Desktop';
    if (spacing.isTablet) return 'Tablet';
    return 'Mobile';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

// DEMO 2: Spacing Values
class SpacingValuesDemo extends StatelessWidget {
  const SpacingValuesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ResponsiveBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Semantic Spacing Values',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap.lg(),

            Text(
              'All spacing values are responsive and scale based on the current breakpoint.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            Gap.lg(),

            // Spacing visualization
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visual Spacing Scale',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.md(),
                    ..._buildSpacingRows(spacing),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Figma integration
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Figma Integration',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Text(
                      'Convert common Figma 8pt grid values:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Gap.md(),
                    ..._buildFigmaRows(spacing),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSpacingRows(OptimizedSpacing spacing) {
    final spacingItems = [
      ('micro', spacing.micro, 'Ultra-fine spacing'),
      ('xs', spacing.xs, 'Extra small'),
      ('sm', spacing.sm, 'Small (base unit)'),
      ('md', spacing.md, 'Medium'),
      ('lg', spacing.lg, 'Large'),
      ('xl', spacing.xl, 'Extra large'),
      ('xxl', spacing.xxl, 'Double extra large'),
      ('xxxl', spacing.xxxl, 'Triple extra large'),
      ('huge', spacing.huge, 'Huge'),
      ('massive', spacing.massive, 'Massive'),
    ];

    return spacingItems.map((item) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(
                item.$1,
                style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: item.$2.clamp(0, 200), // Clamp to reasonable size for display
              height: 20,
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(width: spacing.sm),
            Text('${item.$2.toStringAsFixed(1)}dp'),
            SizedBox(width: spacing.sm),
            Expanded(child: Text('- ${item.$3}', style: TextStyle(color: Colors.grey.shade600))),
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildFigmaRows(OptimizedSpacing spacing) {
    final figmaValues = [4, 8, 12, 16, 24, 32, 48, 64, 96];

    return figmaValues.map((figmaValue) {
      final flutterValue = spacing.figma(figmaValue);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text('${figmaValue}pt', style: const TextStyle(fontFamily: 'monospace')),
            const Text(' → '),
            Text('${flutterValue.toStringAsFixed(1)}dp', style: const TextStyle(fontFamily: 'monospace')),
            SizedBox(width: spacing.sm),
            Container(
              width: flutterValue.clamp(0, 200),
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}

// DEMO 3: Responsive Widgets
class ResponsiveWidgetsDemo extends StatelessWidget {
  const ResponsiveWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ResponsiveBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Responsive Widget Components',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap.lg(),

            // Gap demonstration
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gap Widgets',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Text('Responsive gaps that scale with breakpoints:'),
                    Gap.md(),
                    Row(
                      children: [
                        Container(color: Colors.red.shade200, width: 40, height: 40),
                        Gap.xs(),
                        Container(color: Colors.blue.shade200, width: 40, height: 40),
                        Gap.sm(),
                        Container(color: Colors.green.shade200, width: 40, height: 40),
                        Gap.md(),
                        Container(color: Colors.yellow.shade200, width: 40, height: 40),
                        Gap.lg(),
                        Container(color: Colors.purple.shade200, width: 40, height: 40),
                      ],
                    ),
                    Gap.sm(),
                    Text('XS → SM → MD → LG gaps between boxes', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // ResponsiveSwitch demonstration
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ResponsiveSwitch Widget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Text('Different content based on device type:'),
                    Gap.md(),
                    ResponsiveSwitch<Widget>(
                      phone: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone_android, color: Colors.blue),
                            Gap.sm(),
                            Text('Mobile Layout'),
                          ],
                        ),
                      ),
                      tablet: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.tablet, color: Colors.green),
                            Gap.sm(),
                            Text('Tablet Layout with more space'),
                          ],
                        ),
                      ),
                      desktop: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.purple.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.desktop_windows, color: Colors.purple),
                            Gap.sm(),
                            Text('Desktop Layout with maximum space and features'),
                          ],
                        ),
                      ),
                      fallback: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('Fallback Layout'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // FastGrid demonstration
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FastGrid Widget',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Text('Responsive grid with ${spacing.columns} columns on current device:'),
                    Gap.md(),
                    FastGrid(
                      children: List.generate(12, (index) {
                        return Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.primaries[index % Colors.primaries.length].shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DEMO 5: Optical Adjustments
class OpticalAdjustmentsDemo extends StatefulWidget {
  const OpticalAdjustmentsDemo({super.key});

  @override
  State<OpticalAdjustmentsDemo> createState() => _OpticalAdjustmentsDemoState();
}

class _OpticalAdjustmentsDemoState extends State<OpticalAdjustmentsDemo> {
  bool _showAdjustments = true;
  bool _isArabicText = false;
  double _shadowElevation = 1.0;
  double _fontSizeSlider = 16.0;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return ResponsiveBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Optical Adjustments Demo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap.lg(),

            // Control panel
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Controls',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Row(
                      children: [
                        Text('Show Optical Adjustments:'),
                        const Spacer(),
                        Switch(
                          value: _showAdjustments,
                          onChanged: (value) => setState(() => _showAdjustments = value),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Arabic Text Mode:'),
                        const Spacer(),
                        Switch(
                          value: _isArabicText,
                          onChanged: (value) => setState(() => _isArabicText = value),
                        ),
                      ],
                    ),
                    Gap.sm(),
                    Text('Shadow Elevation: ${_shadowElevation.toStringAsFixed(1)}'),
                    Slider(
                      value: _shadowElevation,
                      min: 0.0,
                      max: 5.0,
                      divisions: 50,
                      onChanged: (value) => setState(() => _shadowElevation = value),
                    ),
                    Text('Font Size: ${_fontSizeSlider.toStringAsFixed(0)}pt'),
                    Slider(
                      value: _fontSizeSlider,
                      min: 12.0,
                      max: 32.0,
                      divisions: 20,
                      onChanged: (value) => setState(() => _fontSizeSlider = value),
                    ),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Typography Adjustments
            _buildTypographyDemo(),
            Gap.lg(),

            // Spacing Adjustments
            _buildSpacingDemo(),
            Gap.lg(),

            // Shadow Adjustments
            _buildShadowDemo(),
            Gap.lg(),

            // Container Adjustments
            _buildContainerDemo(),
            Gap.lg(),

            // List Adjustments
            _buildListDemo(),
            Gap.lg(),

            // Border Radius Adjustments
            _buildBorderRadiusDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Typography Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text(
              'Compare how text looks with and without optical adjustments:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Gap.md(),

            // Comparison grid
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Without Adjustments',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.red.shade700,
                            ),
                      ),
                      Gap.xs(),
                      Container(
                        padding: EdgeInsets.all(spacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isArabicText ? 'عنوان رئيسي' : 'Main Heading',
                              style: TextStyle(
                                fontSize: _fontSizeSlider + 8,
                                fontWeight: FontWeight.bold,
                                height: 1.2, // Standard line height
                                letterSpacing: _isArabicText ? 0.0 : 0.0, // No adjustment
                              ),
                            ),
                            Gap.xs(),
                            Text(
                              _isArabicText
                                  ? 'هذا النص يوضح كيف يبدو النص بدون التعديلات البصرية المناسبة.'
                                  : 'This text shows how content looks without proper optical adjustments.',
                              style: TextStyle(
                                fontSize: _fontSizeSlider,
                                height: 1.2, // Standard line height
                                letterSpacing: _isArabicText ? 0.0 : 0.0, // No adjustment
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'With Optical Adjustments',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: Colors.green.shade700,
                            ),
                      ),
                      Gap.xs(),
                      Container(
                        padding: EdgeInsets.all(spacing.sm),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isArabicText ? 'عنوان رئيسي' : 'Main Heading',
                              style: _showAdjustments
                                  ? OpticalAdjustments.adjustedTextStyle(
                                      fontSize: _fontSizeSlider + 8,
                                      fontWeight: FontWeight.bold,
                                      isArabic: _isArabicText,
                                    )
                                  : TextStyle(
                                      fontSize: _fontSizeSlider + 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                            ),
                            Gap.xs(),
                            Text(
                              _isArabicText
                                  ? 'هذا النص يوضح كيف يبدو النص مع التعديلات البصرية المناسبة للقراءة.'
                                  : 'This text shows how content looks with proper optical adjustments applied.',
                              style: _showAdjustments
                                  ? OpticalAdjustments.adjustedTextStyle(
                                      fontSize: _fontSizeSlider,
                                      fontWeight: FontWeight.normal,
                                      isArabic: _isArabicText,
                                    )
                                  : TextStyle(fontSize: _fontSizeSlider),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap.md(),

            // Typography principles explanation
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.blue.shade700, size: 16),
                      SizedBox(width: spacing.xs),
                      Text(
                        'Typography Adjustments Applied:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  Gap.xs(),
                  Text(
                    '• Line height: Adjusted based on font size (smaller text gets more)\n'
                    '• Letter spacing: Optimized for readability (tighter for headings)\n'
                    '• Arabic support: Zero letter spacing, increased line height\n'
                    '• Font weight: Mapped to available weights in font family',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spacing Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text('Optical spacing adjustments for better visual balance:'),
            Gap.md(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Standard Spacing', style: TextStyle(color: Colors.red.shade700)),
                      Gap.xs(),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 20,
                                color: Colors.red.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                            SizedBox(height: spacing.md), // Standard spacing
                            Container(
                                height: 20,
                                color: Colors.red.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                            SizedBox(height: spacing.md), // Standard spacing
                            Container(
                                height: 20,
                                color: Colors.red.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    children: [
                      Text('Optically Adjusted', style: TextStyle(color: Colors.green.shade700)),
                      Gap.xs(),
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                height: 20,
                                color: Colors.green.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                            SizedBox(
                                height: _showAdjustments
                                    ? OpticalAdjustments.adjustSpacing(spacing.md, factor: 1.15)
                                    : spacing.md),
                            Container(
                                height: 20,
                                color: Colors.green.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                            SizedBox(
                                height: _showAdjustments
                                    ? OpticalAdjustments.adjustSpacing(spacing.md, factor: 1.15)
                                    : spacing.md),
                            Container(
                                height: 20,
                                color: Colors.green.shade300,
                                margin: EdgeInsets.symmetric(horizontal: spacing.md)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shadow Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text('Compare standard vs. optically adjusted shadows:'),
            Gap.md(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('Standard Shadow', style: TextStyle(color: Colors.red.shade700)),
                      Gap.sm(),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8.0 * _shadowElevation,
                              offset: Offset(0, 2.0 * _shadowElevation),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Standard\nShadow',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: spacing.lg),
                Expanded(
                  child: Column(
                    children: [
                      Text('Optical Shadow', style: TextStyle(color: Colors.green.shade700)),
                      Gap.sm(),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: _showAdjustments
                              ? OpticalAdjustments.subtleShadow(elevation: _shadowElevation)
                              : [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8.0 * _shadowElevation,
                                    offset: Offset(0, 2.0 * _shadowElevation),
                                  ),
                                ],
                        ),
                        child: Center(
                          child: Text(
                            'Optically\nAdjusted',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gap.md(),
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Optical shadows use reduced opacity (${(0.03 * _shadowElevation * 100).toStringAsFixed(0)}% vs 20%) '
                'and balanced blur/spread ratios for a more natural appearance.',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Container Padding Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text('Balanced container padding that respects reading direction:'),
            Gap.md(),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: _showAdjustments
                        ? OpticalAdjustments.balancedContainerPadding(
                            context: context,
                            base: spacing.md,
                            topFactor: 1.2,
                            bottomFactor: 1.1,
                            leadingFactor: 1.15,
                            trailingFactor: 0.9,
                          )
                        : EdgeInsets.all(spacing.md),
                    decoration: BoxDecoration(
                      color: _showAdjustments ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _showAdjustments ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _showAdjustments ? 'Optically Balanced' : 'Standard Padding',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _showAdjustments ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                        Gap.xs(),
                        Text(
                          'Notice how the content feels better positioned with optical adjustments. '
                          'More leading padding creates visual anchor, varied vertical padding improves balance.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List Item Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text('Smart margin adjustments for first and last items:'),
            Gap.md(),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  final isFirst = index == 0;
                  final isLast = index == 3;

                  return Container(
                    margin: _showAdjustments
                        ? OpticalAdjustments.listItemMargin(
                            context: context,
                            horizontal: spacing.md,
                            vertical: spacing.sm,
                            isFirst: isFirst,
                            isLast: isLast,
                          )
                        : EdgeInsets.symmetric(
                            horizontal: spacing.md,
                            vertical: spacing.sm / 2,
                          ),
                    padding: EdgeInsets.all(spacing.sm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: _showAdjustments
                          ? OpticalAdjustments.subtleShadow(elevation: 0.5)
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 1),
                              ),
                            ],
                    ),
                    child: Text(
                      'List Item ${index + 1}${isFirst ? ' (First)' : ''}${isLast ? ' (Last)' : ''}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
            Gap.sm(),
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'First and last items get full margins, middle items get half margins to prevent double spacing.',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBorderRadiusDemo() {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Border Radius Adjustments',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Gap.sm(),
            Text('Border radius that scales with element size:'),
            Gap.md(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Small element
                Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade200,
                        borderRadius: BorderRadius.circular(
                            _showAdjustments ? OpticalAdjustments.adjustBorderRadius(8.0, 60) : 8.0),
                      ),
                      child: Center(child: Text('Small', style: TextStyle(fontSize: 10))),
                    ),
                    Gap.xs(),
                    Text('60px', style: TextStyle(fontSize: 12)),
                  ],
                ),

                // Medium element
                Column(
                  children: [
                    Container(
                      width: 120,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade200,
                        borderRadius: BorderRadius.circular(
                            _showAdjustments ? OpticalAdjustments.adjustBorderRadius(8.0, 120) : 8.0),
                      ),
                      child: Center(child: Text('Medium')),
                    ),
                    Gap.xs(),
                    Text('120px', style: TextStyle(fontSize: 12)),
                  ],
                ),

                // Large element
                Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.purple.shade200,
                        borderRadius: BorderRadius.circular(
                            _showAdjustments ? OpticalAdjustments.adjustBorderRadius(8.0, 350) : 8.0),
                      ),
                      child: Center(child: Text('Large')),
                    ),
                    Gap.xs(),
                    Text('350px', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            Gap.md(),
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Small elements get slightly reduced radius (90%), large elements get increased radius (110%) for better visual proportion.',
                style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// DEMO 6: RTL Support
class LayoutExamplesDemo extends StatelessWidget {
  const LayoutExamplesDemo({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: spacing.pagePadding,
            child: Text(
              'Real-world Layout Examples',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Gap.lg(),

          // Card layout example
          ResponsiveBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Card Layout',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Gap.md(),
                FastGrid(
                  children: List.generate(6, (index) => _ProductCard(index)),
                ),
              ],
            ),
          ),

          Gap.xxxl(),

          // Article layout example
          ResponsiveBox(
            maxWidth: spacing.responsive(
              phone: double.infinity,
              tablet: 700,
              desktop: 800,
              fallback: double.infinity,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Article Layout',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Gap.lg(),
                Container(
                  height: spacing.responsive(
                    phone: 200,
                    tablet: 250,
                    desktop: 300,
                    fallback: 200,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                ),
                Gap.lg(),
                Text(
                  'This is a responsive article layout that adapts its typography, spacing, and image sizes based on the current breakpoint.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Gap.md(),
                Text(
                  'The content width is constrained on larger screens for better readability, while mobile devices use the full width. Spacing between elements scales appropriately.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard(this.index);

  final int index;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: spacing.responsive(
                phone: 100,
                tablet: 120,
                desktop: 140,
                fallback: 100,
              ),
              decoration: BoxDecoration(
                color: Colors.primaries[index % Colors.primaries.length].shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  Icons.shopping_bag,
                  size: spacing.responsive(
                    phone: 32,
                    tablet: 40,
                    desktop: 48,
                    fallback: 32,
                  ),
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
              ),
            ),
            Gap.sm(),
            Text(
              'Product ${index + 1}',
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.xs(),
            Text(
              'Description of product ${index + 1}',
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Gap.sm(),
            Text(
              '\$${(index + 1) * 10}.99',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

// DEMO 6: RTL Support
class RTLDemo extends StatefulWidget {
  const RTLDemo({super.key});

  @override
  State<RTLDemo> createState() => _RTLDemoState();
}

class _RTLDemoState extends State<RTLDemo> {
  bool _isRTL = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: ResponsiveBox(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'RTL (Right-to-Left) Support',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Gap.lg(),

              // RTL toggle
              Card(
                child: Padding(
                  padding: context.spacing.cardPadding,
                  child: Row(
                    children: [
                      Text('Enable RTL Mode:'),
                      const Spacer(),
                      Switch(
                        value: _isRTL,
                        onChanged: (value) {
                          setState(() {
                            _isRTL = value;
                          });
                          // Clear cache when RTL changes
                          OptimizedSpacing.clearCache();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              Gap.lg(),

              // RTL-aware alignment demonstration
              Card(
                child: Padding(
                  padding: context.spacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RTL-Aware Alignments',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Gap.md(),
                      _RTLDemoRow('Start Alignment', context.spacing.startAlignment),
                      Gap.sm(),
                      _RTLDemoRow('End Alignment', context.spacing.endAlignment),
                    ],
                  ),
                ),
              ),

              Gap.lg(),

              // Directional padding demonstration
              Card(
                child: Padding(
                  padding: context.spacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Directional Padding',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Gap.md(),
                      Container(
                        width: double.infinity,
                        padding: context.spacing.directional(
                          start: context.spacing.xl,
                          end: context.spacing.sm,
                          top: context.spacing.md,
                          bottom: context.spacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'This container has different start/end padding that respects RTL direction',
                          textAlign: context.spacing.startText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Gap.lg(),

              // Grid with RTL support
              Card(
                child: Padding(
                  padding: context.spacing.cardPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RTL-Aware Grid',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Gap.md(),
                      FastGrid(
                        children: List.generate(8, (index) {
                          return Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.primaries[index % Colors.primaries.length].shade200,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Center(
                              child: Text('${index + 1}'),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RTLDemoRow extends StatelessWidget {
  const _RTLDemoRow(this.label, this.alignment);

  final String label;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Gap.xs(),
        Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Align(
            alignment: alignment,
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text('Box', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// DEMO 7: Performance Test
class PerformanceTestDemo extends StatefulWidget {
  const PerformanceTestDemo({super.key});

  @override
  State<PerformanceTestDemo> createState() => _PerformanceTestDemoState();
}

class _PerformanceTestDemoState extends State<PerformanceTestDemo> {
  int _rebuilds = 0;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  Widget build(BuildContext context) {
    _stopwatch.start();
    _rebuilds++;

    // Measure build time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _stopwatch.stop();
    });

    final spacing = context.spacing;

    return ResponsiveBox(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Demonstration',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Gap.lg(),

            // Performance metrics
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Build Performance',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    _InfoRow('Total Rebuilds', '$_rebuilds'),
                    _InfoRow('Cached Lookups', 'O(1) constant time'),
                    _InfoRow('Memory Usage', 'Minimal - shared instances'),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Stress test with many widgets
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stress Test: 100 Responsive Widgets',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.sm(),
                    Text('Each widget uses optimized spacing calculations:'),
                    Gap.md(),
                    FastGrid(
                      children: List.generate(100, (index) {
                        return Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          padding: EdgeInsets.all(spacing.xs),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(fontSize: spacing.sm),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),

            Gap.lg(),

            // Force rebuild button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    // Force rebuild to test performance
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Force Rebuild'),
              ),
            ),

            Gap.lg(),

            // Performance tips
            Container(
              padding: spacing.cardPadding,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.green.shade700),
                      Gap.sm(),
                      Text(
                        'Performance Optimizations',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  Gap.sm(),
                  Text(
                    '• Compile-time constants for spacing values\n'
                    '• Aggressive caching with shared instances\n'
                    '• O(1) array lookups instead of calculations\n'
                    '• Minimal MediaQuery calls\n'
                    '• Pre-calculated breakpoint detection\n'
                    '• Smart cache invalidation',
                    style: TextStyle(color: Colors.green.shade700),
                  ),
                ],
              ),
            ),

            Gap.lg(),

            // Additional performance insights
            Card(
              child: Padding(
                padding: spacing.cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'System Architecture Benefits',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Gap.md(),
                    _PerformanceFeature(
                      'Compile-time Constants',
                      'All spacing values are calculated at compile time, eliminating runtime calculations.',
                      Icons.flash_on,
                      Colors.orange,
                    ),
                    Gap.sm(),
                    _PerformanceFeature(
                      'Smart Caching',
                      'Aggressive caching with cache invalidation only when necessary (screen size or RTL changes).',
                      Icons.memory,
                      Colors.blue,
                    ),
                    Gap.sm(),
                    _PerformanceFeature(
                      'Minimal MediaQuery',
                      'Only calls MediaQuery.sizeOf() and Directionality.of() - avoids expensive full MediaQuery calls.',
                      Icons.speed,
                      Colors.green,
                    ),
                    Gap.sm(),
                    _PerformanceFeature(
                      'O(1) Lookups',
                      'Pre-calculated arrays enable constant-time lookups for all spacing and breakpoint values.',
                      Icons.trending_up,
                      Colors.purple,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PerformanceFeature extends StatelessWidget {
  const _PerformanceFeature(this.title, this.description, this.icon, this.color);

  final String title;
  final String description;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(context.spacing.xs),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          Gap.sm(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.8),
                  ),
                ),
                Gap.xs(),
                Text(
                  description,
                  style: TextStyle(
                    color: color.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
