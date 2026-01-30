import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

class ApiService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web, or your local IP for real devices.
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const Duration _timeout = Duration(seconds: 5);

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['accessToken']);
        await prefs.setString('userId', data['_id']);
        return {'success': true, 'user': User.fromJson(data)};
      }
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Connection timeout. Is the server running?'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, {required String gender}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password, 'gender': gender}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['accessToken']);
        await prefs.setString('userId', data['_id']);
        return {'success': true, 'user': User.fromJson(data)};
      }
      return {'success': false, 'message': data['message'] ?? 'Registration failed'};
    } catch (e) {
      return {'success': false, 'message': 'Connection timeout. Is the server running?'};
    }
  }

  Future<User> updateProfile(String name, String email, String gender) async {
    final response = await http.put(
      Uri.parse('$baseUrl/auth/profile'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'email': email,
        'gender': gender,
      }),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update profile');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // Posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts')).timeout(_timeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> postsJson = data['posts'];
        return postsJson.map((json) => Post.fromJson(json)).toList();
      }
      throw Exception('Failed to load posts');
    } catch (e) {
      throw Exception('Server unreachable. Please check your connection.');
    }
  }

  Future<Post> createPost(String title, String content, String category) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
      }),
    ).timeout(_timeout);

    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to create post');
  }

  Future<Post> updatePost(String id, String title, String content, String category) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'title': title,
        'content': content,
        'category': category,
      }),
    ).timeout(_timeout);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    }
    throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to update post');
  }

  Future<void> deletePost(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: await _getHeaders(),
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to delete post');
    }
  }

  Future<User?> getMe() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 2)); // Short timeout for auto-login

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Auto-login connection failed: $e');
    }
    return null;
  }
}
