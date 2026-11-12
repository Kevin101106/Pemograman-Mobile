
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/models/food_item.dart';
import 'package:frontend/utils/food_rules.dart';

void main() {
  final foods = [
    FoodItem(
      id: 1,
      name: 'Milk',
      category: 'Dairy',
      quantity: 2,
      storedDate: DateTime(2026, 11, 10),
      useByDate: DateTime(2026, 11, 15),
      location: 'Refrigerator',
    ),
    FoodItem(
      id: 2,
      name: 'Chicken',
      category: 'Meat',
      quantity: 1,
      storedDate: DateTime(2026, 11, 10),
      useByDate: DateTime(2026, 11, 13),
      location: 'Freezer',
    ),
    FoodItem(
      id: 3,
      name: 'Yogurt',
      category: 'Dairy',
      quantity: 4,
      storedDate: DateTime(2026, 11, 11),
      useByDate: DateTime(2026, 11, 17),
      location: 'Refrigerator',
    ),
  ];

  group('Food Sorting', () {
    test('Sorts foods by earliest use-by date first', () {
      final result = FoodRules.sortFoods(
        foods,
        ascending: true,
      );

      expect(
        result.map((food) => food.name).toList(),
        ['Chicken', 'Milk', 'Yogurt'],
      );
    });

    test('Sorts foods by latest use-by date first', () {
      final result = FoodRules.sortFoods(
        foods,
        ascending: false,
      );

      expect(
        result.map((food) => food.name).toList(),
        ['Yogurt', 'Milk', 'Chicken'],
      );
    });

    test('Does not change the original food list', () {
      final originalOrder = foods.map((food) => food.name).toList();

      FoodRules.sortFoods(
        foods,
        ascending: true,
      );

      expect(
        foods.map((food) => food.name).toList(),
        originalOrder,
      );
    });

    test('Returns an empty list when there are no foods', () {
      final result = FoodRules.sortFoods([]);

      expect(result, isEmpty);
    });
  });
}
