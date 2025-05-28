# Mobile Ultra Spacing

A comprehensive Flutter package for managing responsive spacing, breakpoint detection, and optical adjustments across all screen sizes. Built with performance and visual consistency in mind, supporting both LTR and RTL layouts.

## Features

- 🎯 **Ultra-fast responsive spacing** with O(1) lookups and aggressive caching
- 📱 **8 precise breakpoints** from phone to desktop with automatic detection
- 🔄 **Full RTL support** with directional-aware padding and alignment
- 👁️ **Optical adjustments** based on design principles for better UI perception
- 🏗️ **Ready-to-use widgets** for gaps, containers, grids, and responsive layouts
- ⚡ **Performance optimized** with compile-time constants and minimal rebuilds

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  mobile_ultra_spacing: ^0.1.0
```

Then run:
```bash
flutter pub get
```

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ResponsiveBox(
          child: Column(
            children: [
              Text('Responsive Layout'),
              Gap.md(), // Responsive gap
              Container(
                padding: context.spacing.cardPadding,
                child: Text('Auto-sized card'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## Core Concepts

### Breakpoints

The package defines 8 breakpoints that automatically adapt to your screen:

| Breakpoint | Min Width | Typical Device |
|------------|-----------|----------------|
| `phoneSmall` | 0px | Small phones |
| `phoneMedium` | 375px | iPhone, most Android |
| `phoneLarge` | 430px | iPhone Pro Max |
| `tabletSmall` | 500px | Small tablets |
| `tabletMedium` | 680px | iPad Mini |
| `tabletLarge` | 820px | iPad |
| `tabletXLarge` | 1000px | iPad Pro |
| `desktop` | 1200px | Laptops & desktops |

### Spacing System

Each breakpoint has carefully calculated spacing values that scale appropriately:

- **Base spacing**: 4dp (phone) → 8dp (desktop)
- **Semantic sizes**: `xs`, `sm`, `md`, `lg`, `xl`, `xxl`, `xxxl`, `huge`, `massive`
- **Contextual spacing**: `margin`, `gutter` for layout-specific needs

## Usage Guide

### 1. Basic Spacing

#### Access spacing values:
```dart
@override
Widget build(BuildContext context) {
  final spacing = context.spacing;
  
  return Container(
    padding: EdgeInsets.all(spacing.md), // Responsive medium spacing
    margin: EdgeInsets.symmetric(horizontal: spacing.margin),
    child: Text('Responsive content'),
  );
}
```

#### Quick device checks:
```dart
Widget build(BuildContext context) {
  if (context.isMobile) {
    return CompactLayout();
  } else if (context.isTablet) {
    return TabletLayout();
  } else {
    return DesktopLayout();
  }
}
```

### 2. Responsive Values

Select different values based on screen size:

```dart
// Using the spacing system
final fontSize = context.spacing.responsive<double>(
  phone: 16.0,
  tablet: 18.0,
  desktop: 20.0,
  fallback: 16.0,
);

// Using standalone function
final columns = responsive(context,
  phone: 1,
  tablet: 2,
  desktop: 3,
  fallback: 1,
);
```

### 3. Ready-to-Use Widgets

#### Gap - Responsive spacing
```dart
Column(
  children: [
    Text('Title'),
    Gap.lg(), // Large responsive gap
    Text('Content'),
    Gap.sm(), // Small responsive gap
    ElevatedButton(onPressed: () {}, child: Text('Button')),
  ],
)
```

#### ResponsiveBox - Auto-sizing container
```dart
ResponsiveBox(
  child: Column(
    children: [
      // Content automatically gets proper padding
      // and max-width constraints
      Text('This content is perfectly sized for any screen'),
    ],
  ),
)
```

#### ResponsiveSwitch - Device-specific widgets
```dart
ResponsiveSwitch<Widget>(
  phone: MobileNavigation(),
  tablet: TabletNavigation(), 
  desktop: DesktopNavigation(),
  fallback: MobileNavigation(),
)
```

#### FastGrid - Performance-optimized grid
```dart
FastGrid(
  children: List.generate(20, (index) => 
    Card(child: Text('Item $index')),
  ),
  // Columns auto-adjust: 1-2 (phone) → 6 (desktop)
  // Spacing auto-scales with breakpoint
)
```

### 4. RTL Support

Full right-to-left language support built-in:

```dart
// Directional padding
Container(
  padding: context.spacing.directional(
    start: 16.0,  // Padding at text start (right in RTL)
    end: 8.0,     // Padding at text end (left in RTL)
  ),
  child: Text('مرحبا'), // Arabic text
)

// RTL-aware alignment
Text(
  'Content',
  textAlign: context.spacing.startText, // Right in RTL, left in LTR
)
```

### 5. Optical Adjustments

Fine-tune your UI based on human perception principles:

#### Typography adjustments
```dart
Text(
  'Perfectly balanced text',
  style: OpticalAdjustments.adjustedTextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
    isArabic: false, // Set to true for Arabic text
  ),
)
```

#### Visual spacing
```dart
Container(
  padding: OpticalAdjustments.balancedContainerPadding(
    context: context,
    base: 16.0,
    topFactor: 1.25,    // Slightly more top padding
    leadingFactor: 1.1, // More padding at reading start
  ),
  child: content,
)
```

#### Subtle shadows
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    boxShadow: OpticalAdjustments.subtleShadow(elevation: 2.0),
  ),
  child: content,
)
```

### 6. Figma Integration

Convert Figma spacing directly to your app's responsive values:

```dart
// Direct conversion from Figma's 8pt grid
final spacing = context.spacing;
final figmaSpacing = spacing.figma(24); // 24pt from Figma → responsive value

// Auto-scaled conversion
final scaledSpacing = spacing.figmaScaled(32); // Scales with breakpoint
```

## Advanced Usage

### Performance Optimization

The package uses several optimization techniques:

1. **Aggressive caching**: Spacing calculations are cached until screen size changes
2. **Compile-time constants**: All spacing scales are pre-calculated
3. **O(1) lookups**: No expensive calculations during builds

```dart
// Clear cache manually if needed (rarely required)
OptimizedSpacing.clearCache();
```

### Custom Breakpoints

While the default 8 breakpoints work for most apps, you can use the breakpoint system directly:

```dart
// Access current breakpoint
final breakpoint = context.breakpoint;

// Use AppSpacing for more control
final appSpacing = AppSpacing.of(context);
final customValue = appSpacing.responsive<double>(
  phone: 12.0,
  tablet: 16.0,
  desktop: 20.0,
  fallback: 12.0,
);
```

### Responsive Builders

Create complex responsive layouts:

```dart
ResponsiveBuilder(
  phone: (context, spacing) => MobileLayout(spacing: spacing),
  tablet: (context, spacing) => TabletLayout(spacing: spacing),
  desktop: (context, spacing) => DesktopLayout(spacing: spacing),
  builder: (context, spacing) => DefaultLayout(spacing: spacing),
)
```

## API Reference

### OptimizedSpacing

| Property | Description | Example |
|----------|-------------|---------|
| `base` | Base spacing unit | `4.0` → `8.0` |
| `margin` | Standard margin | `16.0` → `80.0` |
| `gutter` | Grid gutter spacing | `8.0` → `40.0` |
| `xs` → `massive` | Semantic sizes | `2.0` → `128.0` |
| `isMobile` | Device type check | `true`/`false` |
| `isRTL` | Text direction | `true`/`false` |

### Pre-built Padding

| Method | Use Case |
|--------|----------|
| `pagePadding` | Page-level content |
| `cardPadding` | Card components |
| `buttonPadding` | Interactive elements |
| `inputPadding` | Form fields |
| `modalPadding` | Overlays and modals |

### Widgets

| Widget | Purpose |
|--------|---------|
| `Gap` | Responsive spacing |
| `ResponsiveBox` | Auto-sizing container |
| `ResponsiveSwitch` | Device-specific content |
| `FastGrid` | Performance grid |
| `ResponsiveBuilder` | Custom responsive layouts |

## Best Practices

1. **Use semantic spacing**: Prefer `spacing.lg` over hardcoded values
2. **Leverage device checks**: Use `context.isMobile` for conditional logic
3. **Apply optical adjustments**: Use `OpticalAdjustments` for professional polish
4. **Consider RTL early**: Use directional padding and alignment helpers
5. **Test across breakpoints**: Verify your layouts work on all screen sizes

## Examples

Check out the `/example` folder for complete sample apps demonstrating:
- Basic responsive layout
- RTL language support
- Optical adjustment techniques
- Performance optimization
- Figma workflow integration

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Made with ❤️ for the Flutter community**