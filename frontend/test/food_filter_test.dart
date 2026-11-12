
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

  group('Food Filtering', () {
    test('Searches food by name', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        query: 'Milk',
      );

      expect(result.length, 1);
      expect(result.first.name, 'Milk');
    });

    test('Search is case-insensitive and ignores extra spaces', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        query: '  MILK  ',
      );

      expect(result.length, 1);
      expect(result.first.name, 'Milk');
    });

    test('Filters food by category', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        category: 'Dairy',
      );

      expect(result.length, 2);
      expect(result.every((food) => food.category == 'Dairy'), isTrue);
    });

    test('Filters food by storage location', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        location: 'Freezer',
      );

      expect(result.length, 1);
      expect(result.first.name, 'Chicken');
    });

    test('Combines search, category, and location filters', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        query: 'Yo',
        category: 'Dairy',
        location: 'Refrigerator',
      );

      expect(result.length, 1);
      expect(result.first.name, 'Yogurt');
    });

    test('Returns all foods when filters are set to All', () {
      final result = FoodRules.filterFoods(
        foods: foods,
        category: 'All',
        location: 'All',
      );

      expect(result.length, 3);
    });
  });
}
