
import '../models/food_item.dart';

class FoodRules {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Food name is required.';
    }
    return null;
  }

  static String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required.';
    }

    final quantity = int.tryParse(value.trim());

    if (quantity == null || quantity <= 0) {
      return 'Enter a whole number greater than 0.';
    }

    return null;
  }

  static String? validateDates(DateTime storedDate, DateTime useByDate) {
    final stored = DateTime(storedDate.year, storedDate.month, storedDate.day);
    final useBy = DateTime(useByDate.year, useByDate.month, useByDate.day);

    if (useBy.isBefore(stored)) {
      return 'Use-by Date cannot be before Stored Date.';
    }

    return null;
  }

  static String getStatus(DateTime useByDate, {DateTime? today}) {
    final currentDate = today ?? DateTime.now();
    final current = DateTime(currentDate.year, currentDate.month, currentDate.day);
    final expiry = DateTime(useByDate.year, useByDate.month, useByDate.day);

    if (expiry.isBefore(current)) return 'Past Due';
    if (expiry.difference(current).inDays <= 2) return 'Use Soon';

    return 'Fresh';
  }

  static List<FoodItem> filterFoods({
    required List<FoodItem> foods,
    String query = '',
    String category = 'All',
    String location = 'All',
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return foods.where((food) {
      final matchesName = food.name.toLowerCase().contains(normalizedQuery);
      final matchesCategory = category == 'All' || food.category == category;
      final matchesLocation = location == 'All' || food.location == location;

      return matchesName && matchesCategory && matchesLocation;
    }).toList();
  }

  static List<FoodItem> sortFoods(List<FoodItem> foods, {bool ascending = true}) {
    final result = List<FoodItem>.from(foods);

    result.sort((a, b) {
      final comparison = a.useByDate.compareTo(b.useByDate);
      return ascending ? comparison : -comparison;
    });

    return result;
  }
}
