
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/food_item.dart';

void main() {
  group('FoodItem Model', () {
    test('Converts JSON data into FoodItem correctly', () {
      final json = {
        'id': 1,
        'name': 'Milk',
        'category': 'Dairy',
        'quantity': 2,
        'stored_date': '2026-11-06',
        'use_by_date': '2026-11-10',
        'location': 'Refrigerator',
      };

      final food = FoodItem.fromJson(json);

      expect(food.id, 1);
      expect(food.name, 'Milk');
      expect(food.category, 'Dairy');
      expect(food.quantity, 2);
      expect(food.storedDate, DateTime(2026, 11, 6));
      expect(food.useByDate, DateTime(2026, 11, 10));
      expect(food.location, 'Refrigerator');
    });

    test('Converts decimal JSON quantity into a whole number', () {
      final json = {
        'id': 2,
        'name': 'Yogurt',
        'category': 'Dairy',
        'quantity': 3.0,
        'stored_date': '2026-11-06',
        'use_by_date': '2026-11-12',
        'location': 'Refrigerator',
      };

      final food = FoodItem.fromJson(json);

      expect(food.quantity, 3);
    });

    test('Converts FoodItem into JSON correctly', () {
      final food = FoodItem(
        id: 1,
        name: 'Milk',
        category: 'Dairy',
        quantity: 2,
        storedDate: DateTime(2026, 11, 6),
        useByDate: DateTime(2026, 11, 10),
        location: 'Refrigerator',
      );

      final json = food.toJson();

      expect(json, {
        'name': 'Milk',
        'category': 'Dairy',
        'quantity': 2,
        'stored_date': '2026-11-06',
        'use_by_date': '2026-11-10',
        'location': 'Refrigerator',
      });
    });

    test('Does not include ID when converting FoodItem into JSON', () {
      final food = FoodItem(
        id: 10,
        name: 'Eggs',
        category: 'Dairy',
        quantity: 6,
        storedDate: DateTime(2026, 11, 6),
        useByDate: DateTime(2026, 11, 15),
        location: 'Refrigerator',
      );

      expect(food.toJson().containsKey('id'), isFalse);
    });
  });
}
