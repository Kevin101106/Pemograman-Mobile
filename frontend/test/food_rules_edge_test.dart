
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/food_item.dart';
import 'package:frontend/utils/food_rules.dart';

void main() {
  group('FoodRules Edge Cases', () {
    group('Name Validation', () {
      test('accepts name with surrounding spaces', () {
        expect(FoodRules.validateName(' Milk '), isNull);
      });

      test('accepts name with numbers', () {
        expect(FoodRules.validateName('Milk 123'), isNull);
      });
    });

    group('Quantity Validation', () {
      test('accepts quantity with leading zeros', () {
        expect(FoodRules.validateQuantity('005'), isNull);
      });

      test('accepts quantity with plus sign', () {
        expect(FoodRules.validateQuantity('+5'), isNull);
      });

      test('accepts quantity with surrounding spaces', () {
        expect(FoodRules.validateQuantity(' 5 '), isNull);
      });

      test('rejects decimal quantity', () {
        expect(
          FoodRules.validateQuantity('2.5'),
          'Enter a whole number greater than 0.',
        );
      });
    });

    group('Date Validation', () {
      test('accepts same calendar date with different times', () {
        expect(
          FoodRules.validateDates(
            DateTime(2026, 11, 27, 20),
            DateTime(2026, 11, 27, 8),
          ),
          isNull,
        );
      });

      test('accepts use-by date in the next month', () {
        expect(
          FoodRules.validateDates(
            DateTime(2026, 11, 30),
            DateTime(2026, 12, 1),
          ),
          isNull,
        );
      });

      test('accepts use-by date in the next year', () {
        expect(
          FoodRules.validateDates(
            DateTime(2026, 12, 31),
            DateTime(2027, 1, 1),
          ),
          isNull,
        );
      });
    });

    group('Food Status Edge Cases', () {
      test('returns Use Soon exactly two days before expiry', () {
        expect(
          FoodRules.getStatus(
            DateTime(2026, 11, 29),
            today: DateTime(2026, 11, 27),
          ),
          'Use Soon',
        );
      });

      test('returns Fresh exactly three days before expiry', () {
        expect(
          FoodRules.getStatus(
            DateTime(2026, 11, 30),
            today: DateTime(2026, 11, 27),
          ),
          'Fresh',
        );
      });

      test('returns Past Due one day after expiry', () {
        expect(
          FoodRules.getStatus(
            DateTime(2026, 11, 26),
            today: DateTime(2026, 11, 27),
          ),
          'Past Due',
        );
      });

      test('uses supplied today date instead of system date', () {
        expect(
          FoodRules.getStatus(
            DateTime(2026, 12, 10),
            today: DateTime(2026, 12, 1),
          ),
          'Fresh',
        );
      });
    });

    group('Food Filtering Edge Cases', () {
      final foods = [
        FoodItem(
          name: 'Milk',
          category: 'Dairy',
          quantity: 2,
          storedDate: DateTime(2026, 11, 20),
          useByDate: DateTime(2026, 11, 30),
          location: 'Fridge',
        ),
        FoodItem(
          name: 'Apple',
          category: 'Fruit',
          quantity: 5,
          storedDate: DateTime(2026, 11, 21),
          useByDate: DateTime(2026, 12, 1),
          location: 'Pantry',
        ),
      ];

      test('returns all foods for whitespace-only query', () {
        expect(
          FoodRules.filterFoods(foods: foods, query: '   ').length,
          2,
        );
      });

      test('returns empty list when no food matches query', () {
        expect(
          FoodRules.filterFoods(foods: foods, query: 'Chicken'),
          isEmpty,
        );
      });

      test('category matching is case-sensitive', () {
        expect(
          FoodRules.filterFoods(
            foods: foods,
            category: 'dairy',
          ),
          isEmpty,
        );
      });

      test('location matching is case-sensitive', () {
        expect(
          FoodRules.filterFoods(
            foods: foods,
            location: 'fridge',
          ),
          isEmpty,
        );
      });
    });

    group('Food Sorting Edge Cases', () {
      test('returns an empty list when sorting an empty list', () {
        expect(FoodRules.sortFoods([]), isEmpty);
      });

      test('does not remove foods with identical expiry dates', () {
        final foods = [
          FoodItem(
            name: 'Milk',
            category: 'Dairy',
            quantity: 1,
            storedDate: DateTime(2026, 11, 20),
            useByDate: DateTime(2026, 11, 30),
            location: 'Fridge',
          ),
          FoodItem(
            name: 'Cheese',
            category: 'Dairy',
            quantity: 1,
            storedDate: DateTime(2026, 11, 21),
            useByDate: DateTime(2026, 11, 30),
            location: 'Fridge',
          ),
        ];

        expect(FoodRules.sortFoods(foods).length, 2);
      });
    });

    group('FoodItem Serialization Edge Cases', () {
      test('creates FoodItem when JSON id is null', () {
        final food = FoodItem.fromJson({
          'id': null,
          'name': 'Milk',
          'category': 'Dairy',
          'quantity': 2,
          'stored_date': '2026-11-20',
          'use_by_date': '2026-11-30',
          'location': 'Fridge',
        });

        expect(food.id, isNull);
        expect(food.name, 'Milk');
      });

      test('converts date-time values to date-only strings in JSON', () {
        final food = FoodItem(
          name: 'Milk',
          category: 'Dairy',
          quantity: 2,
          storedDate: DateTime(2026, 11, 20, 15, 30),
          useByDate: DateTime(2026, 11, 30, 18, 45),
          location: 'Fridge',
        );

        final json = food.toJson();

        expect(json['stored_date'], '2026-11-20');
        expect(json['use_by_date'], '2026-11-30');
      });
    });
  });
}
