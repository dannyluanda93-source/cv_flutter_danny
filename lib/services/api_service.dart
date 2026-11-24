import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000/api';
  static const String _tokenKey = 'auth_token';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) {
      await saveToken(data['token'] as String);
    }
    return data;
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<Map<String, String>> headers() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<List<dynamic>> getFamille() async {
    final response = await http.get(
      Uri.parse('$baseUrl/famille'),
      headers: await headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    }
    throw Exception(jsonDecode(response.body)['error'] ?? 'Erreur famille');
  }

  static Future<void> addFamille(Map<String, dynamic> member) async {
    final response = await http.post(
      Uri.parse('$baseUrl/famille'),
      headers: await headers(),
      body: jsonEncode(member),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Ajout impossible');
    }
  }

  static Future<void> updateFamille(int id, Map<String, dynamic> member) async {
    final response = await http.put(
      Uri.parse('$baseUrl/famille/$id'),
      headers: await headers(),
      body: jsonEncode(member),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Modification impossible');
    }
  }

  static Future<void> deleteFamille(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille/$id'),
      headers: await headers(),
    );
    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['error'] ?? 'Suppression impossible');
    }
  }
}
