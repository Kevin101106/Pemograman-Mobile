
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/food_rules.dart';

void main() {
  group('Food Expiry Status', () {
    final today = DateTime(2026, 11, 13);

    test('Returns Past Due when food has expired', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 12),
        today: today,
      );

      expect(status, 'Past Due');
    });

    test('Returns Use Soon when food expires today', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 13),
        today: today,
      );

      expect(status, 'Use Soon');
    });

    test('Returns Use Soon when food expires tomorrow', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 14),
        today: today,
      );

      expect(status, 'Use Soon');
    });

    test('Returns Use Soon when food expires in two days', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 15),
        today: today,
      );

      expect(status, 'Use Soon');
    });

    test('Returns Fresh when food expires in three days', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 16),
        today: today,
      );

      expect(status, 'Fresh');
    });

    test('Ignores time of day when checking expiry status', () {
      final status = FoodRules.getStatus(
        DateTime(2026, 11, 13, 23, 59),
        today: DateTime(2026, 11, 13, 1, 0),
      );

      expect(status, 'Use Soon');
    });
  });
}
