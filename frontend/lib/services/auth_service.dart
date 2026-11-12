import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage();

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await _saveSession(data);
      return data;
    }

    throw Exception(data['message'] ?? 'Login gagal');
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      await _saveSession(data);
      return data;
    }

    if (data['errors'] != null) {
      final errors = data['errors'] as Map<String, dynamic>;
      throw Exception(errors.values.first.first);
    }

    throw Exception(data['message'] ?? 'Registrasi gagal');
  }

  Future<void> _saveSession(Map<String, dynamic> data) async {
    final preferences = await SharedPreferences.getInstance();

    await _secureStorage.write(
      key: 'auth_token',
      value: data['token'],
    );

    await preferences.setString('user_name', data['user']['name']);
    await preferences.setString('user_email', data['user']['email']);
  }

  Future<bool> checkSession() async {
    final preferences = await SharedPreferences.getInstance();
    final token = await _secureStorage.read(key: 'auth_token');

    if (token == null || token.isEmpty) {
      return false;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final user = jsonDecode(response.body);

        await preferences.setString('user_name', user['name']);
        await preferences.setString('user_email', user['email']);

        return true;
      }
    } catch (_) {
      debugPrint('Session validation failed.');
    }

    await clearSession();
    return false;
  }

  Future<String?> getUserName() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('user_name');
  }

  Future<String?> getUserEmail() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString('user_email');
  }

  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<void> logout() async {
    final token = await getToken();

    try {
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } finally {
      await clearSession();
    }
  }

  Future<void> clearSession() async {
    final preferences = await SharedPreferences.getInstance();

    await _secureStorage.delete(key: 'auth_token');
    await preferences.remove('user_name');
    await preferences.remove('user_email');
  }
}
