# Contributing to Mobile Ultra Spacing

Thank you for your interest in contributing to Mobile Ultra Spacing! We welcome contributions from the Flutter community and appreciate your help in making this package better.

## 🎯 How to Contribute

There are many ways you can contribute to this project:

- 🐛 **Report bugs** or suggest improvements
- 📝 **Improve documentation** or add examples
- ✨ **Add new features** or enhance existing ones
- 🧪 **Write tests** to improve code coverage
- 🔧 **Fix issues** from the issue tracker
- 💬 **Help others** in discussions and issues

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git
- A code editor (VS Code, Android Studio, etc.)

### Setting Up the Development Environment

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/KhaledSMQ/mobile_ultra_spacing.git
   cd mobile_ultra_spacing
   ```

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Run the example app** to verify setup:
   ```bash
   cd example
   flutter pub get
   flutter run
   ```

5. **Run tests** to ensure everything works:
   ```bash
   flutter test
   ```

6. **Check code quality**:
   ```bash
   flutter analyze
   dart format . --set-exit-if-changed
   ```

## 📋 Development Workflow

### Branch Naming Convention

Use descriptive branch names with prefixes:

- `feature/add-new-breakpoint` - New features
- `fix/rtl-alignment-issue` - Bug fixes
- `docs/update-readme` - Documentation updates
- `test/spacing-utils-coverage` - Test additions
- `refactor/optimize-caching` - Code refactoring

### Making Changes

1. **Create a new branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes** following our coding standards
3. **Add tests** for new functionality
4. **Update documentation** if needed
5. **Test your changes**:
   ```bash
   flutter test
   flutter analyze
   dart format .
   ```

6. **Commit your changes** with clear messages:
   ```bash
   git commit -m "feat: add new responsive alignment helpers"
   ```

## 🎨 Coding Standards

### Code Style

We follow standard Dart/Flutter conventions:

- Use `dart format` to format your code
- Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Add documentation comments for public APIs

### File Organization

```
lib/
├── mobile_ultra_spacing.dart          # Main export file
└── src/
    ├── spacing_utils.dart             # Core spacing functionality
    ├── optical_adjustments.dart       # Visual adjustment utilities
    └── breakpoints.dart               # Breakpoint management
```

### Documentation

- **Public APIs** must have comprehensive documentation comments
- **Complex algorithms** should include inline comments
- **Examples** should be provided for public methods
- **README updates** are required for new features

Example documentation format:

```dart
/// Creates a responsive gap widget with semantic sizing.
///
/// The gap automatically adjusts its size based on the current breakpoint,
/// providing consistent spacing across different screen sizes.
///
/// Example:
/// ```dart
/// Column(
///   children: [
///     Text('Title'),
///     Gap.lg(), // Large responsive gap
///     Text('Content'),
///   ],
/// )
/// ```
///
/// See also:
/// * [ResponsiveBox] for responsive containers
/// * [OptimizedSpacing] for direct spacing access
class Gap extends StatelessWidget {
  // Implementation...
}
```

## 🧪 Testing Guidelines

### Test Structure

- **Unit tests** for core functionality (`test/`)
- **Widget tests** for UI components
- **Integration tests** for complex workflows
- **Golden tests** for visual regression (if applicable)

### Writing Tests

1. **Follow the AAA pattern**: Arrange, Act, Assert
2. **Use descriptive test names** that explain the behavior
3. **Test edge cases** and error conditions
4. **Mock external dependencies** when needed

Example test structure:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

void main() {
  group('OptimizedSpacing', () {
    testWidgets('should provide correct base spacing for phone breakpoint', (tester) async {
      // Arrange
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) {
            // Act
            final spacing = OptimizedSpacing.of(context);

            // Assert
            expect(spacing.base, equals(4.0));
            return Container();
          },
        ),
      ));
    });
  });
}
```

### Test Coverage

- Aim for **80%+ code coverage** for new features
- **Critical paths** must be 100% covered
- Run coverage reports: `flutter test --coverage`

## 📚 Documentation Standards

### README Updates

When adding new features, update the README with:

- Clear usage examples
- API reference entries
- Best practices
- Migration guides (for breaking changes)

### Code Comments

```dart
// Good: Explains the why, not just the what
// Reduces opacity to create more natural shadow appearance
final baseOpacity = 0.03 * elevation;

// Bad: States the obvious
// Set the opacity variable
final baseOpacity = 0.03 * elevation;
```

### Changelog Updates

Follow [Keep a Changelog](https://keepachangelog.com/) format:

```markdown
## [Unreleased]

### Added

- New responsive alignment helpers for improved RTL support

### Changed

- Improved caching performance in OptimizedSpacing class

### Fixed

- Fixed gap widget sizing on very small screens
```

## 🐛 Reporting Issues

### Bug Reports

Please include:

- **Flutter/Dart version**: `flutter --version`
- **Package version**: From your `pubspec.yaml`
- **Platform**: iOS, Android, Web, Desktop
- **Minimal reproduction**: Code that demonstrates the issue
- **Expected vs actual behavior**
- **Screenshots** (if UI-related)

### Feature Requests

Please provide:

- **Clear use case**: Why is this feature needed?
- **Proposed API**: How should it work?
- **Examples**: Show expected usage
- **Alternatives considered**: Other approaches you've tried

## 🔄 Pull Request Process

### Before Submitting

- [ ] Tests pass: `flutter test`
- [ ] No analysis issues: `flutter analyze`
- [ ] Code is formatted: `dart format .`
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Example app works with changes

### PR Description Template

```markdown
## Description

Brief description of changes made.

## Type of Change

- [ ] Bug fix (non-breaking change that fixes an issue)
- [ ] New feature (non-breaking change that adds functionality)
- [ ] Breaking change (fix or feature that causes existing functionality to change)
- [ ] Documentation update

## Testing

- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)

Add screenshots for UI changes.

## Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Tests added for new functionality
```

### Review Process

1. **Automated checks** must pass (CI/CD)
2. **Code review** by maintainers
3. **Testing** on multiple platforms
4. **Documentation review**
5. **Approval and merge**

## 🌟 Recognition

Contributors will be:

- **Listed in CONTRIBUTORS.md**
- **Mentioned in release notes**
- **Recognized in package documentation**

## 📞 Getting Help

- **GitHub Discussions**: For questions and community support
- **GitHub Issues**: For bug reports and feature requests
- **Email**: For security concerns or private matters

## 🏆 Contribution Guidelines

### Small Contributions

- Typo fixes
- Documentation improvements
- Small bug fixes

These can be submitted directly as PRs.

### Large Contributions

- New features
- Breaking changes
- Major refactoring

Please **create an issue first** to discuss the approach and get feedback.

### Performance Considerations

This package prioritizes performance. When contributing:

- **Measure impact** of changes on build/runtime performance
- **Avoid unnecessary rebuilds** in widgets
- **Use const constructors** where possible
- **Leverage caching** for expensive operations
- **Profile your changes** on different devices

### Breaking Changes

Breaking changes should:

- Be **well-justified** with clear benefits
- Include **migration guides**
- Follow **semantic versioning**
- Be **documented thoroughly**

## 📄 License

By contributing to Mobile Ultra Spacing, you agree that your contributions will be licensed under the MIT License.

---

## 🙏 Thank You

Your contributions make Mobile Ultra Spacing better for the entire Flutter community. We appreciate your time and effort in helping improve this package!

**Happy coding! 🚀**