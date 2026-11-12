
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/utils/food_rules.dart';

void main() {
  group('Food Name Validation', () {
    test('Accepts a valid food name', () {
      expect(FoodRules.validateName('Chicken'), isNull);
    });

    test('Rejects an empty food name', () {
      expect(
        FoodRules.validateName(''),
        'Food name is required.',
      );
    });

    test('Rejects a name containing only spaces', () {
      expect(
        FoodRules.validateName('   '),
        'Food name is required.',
      );
    });

    test('Rejects a null food name', () {
      expect(
        FoodRules.validateName(null),
        'Food name is required.',
      );
    });
  });

  group('Quantity Validation', () {
    test('Accepts a positive whole number', () {
      expect(FoodRules.validateQuantity('5'), isNull);
    });

    test('Rejects an empty quantity', () {
      expect(
        FoodRules.validateQuantity(''),
        'Quantity is required.',
      );
    });

    test('Rejects zero quantity', () {
      expect(
        FoodRules.validateQuantity('0'),
        'Enter a whole number greater than 0.',
      );
    });

    test('Rejects negative quantity', () {
      expect(
        FoodRules.validateQuantity('-2'),
        'Enter a whole number greater than 0.',
      );
    });

    test('Rejects decimal quantity', () {
      expect(
        FoodRules.validateQuantity('2.5'),
        'Enter a whole number greater than 0.',
      );
    });

    test('Rejects non-numeric quantity', () {
      expect(
        FoodRules.validateQuantity('abc'),
        'Enter a whole number greater than 0.',
      );
    });
  });

  group('Date Validation', () {
    final storedDate = DateTime(2026, 11, 10);

    test('Accepts use-by date after stored date', () {
      expect(
        FoodRules.validateDates(
          storedDate,
          DateTime(2026, 11, 15),
        ),
        isNull,
      );
    });

    test('Accepts use-by date equal to stored date', () {
      expect(
        FoodRules.validateDates(
          storedDate,
          DateTime(2026, 11, 10),
        ),
        isNull,
      );
    });

    test('Rejects use-by date before stored date', () {
      expect(
        FoodRules.validateDates(
          storedDate,
          DateTime(2026, 11, 9),
        ),
        'Use-by Date cannot be before Stored Date.',
      );
    });
  });
}
