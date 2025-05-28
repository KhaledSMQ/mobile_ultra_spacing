import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ultra_spacing/mobile_ultra_spacing.dart';

void main() {
  group('SpacingConstants', () {
    test('baseValues should have correct length', () {
      expect(SpacingConstants.baseValues.length, 8);
    });

    test('marginScale should have correct length', () {
      expect(SpacingConstants.marginScale.length, 8);
    });
  });
}
