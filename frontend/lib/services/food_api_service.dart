
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class FoodApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/foods';

  Future<List<FoodItem>> getFoods() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => FoodItem.fromJson(item)).toList();
    }

    throw Exception('Failed to load foods');
  }

  Future<FoodItem> addFood(FoodItem food) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(food.toJson()),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return FoodItem.fromJson(data['data']);
    }

    throw Exception('Failed to add food: ${response.body}');
  }

  Future<FoodItem> updateFood(FoodItem food) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${food.id}'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(food.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return FoodItem.fromJson(data['data']);
    }

    throw Exception('Failed to update food: ${response.body}');
  }

  Future<void> deleteFood(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete food: ${response.body}');
    }
  }
}
