
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';
import 'auth_service.dart';

class FoodApiService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/foods';

  final AuthService authService = AuthService();

  Future<Map<String, String>> _headers({bool json = false}) async {
    final token = await authService.getToken();

    return {
      'Accept': 'application/json',
      if (json) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<FoodItem>> getFoods() async {
    final response = await http.get(
      Uri.parse(baseUrl),
      headers: await _headers(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => FoodItem.fromJson(item)).toList();
    }

    throw Exception('Failed to load foods: ${response.body}');
  }

  Future<FoodItem> addFood(FoodItem food) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: await _headers(json: true),
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
      headers: await _headers(json: true),
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
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete food: ${response.body}');
    }
  }
}
