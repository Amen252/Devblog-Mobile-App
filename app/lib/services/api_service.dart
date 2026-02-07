import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

// ApiService waa halka kaliya ee app-ku kula xiriiro backend-ka
// Dhammaan HTTP requests halkan ayay maraan
class ApiService {

  // Haddii true yahay, app-ku wuxuu isticmaalayaa backend-ka live
  // Haddii false yahay, wuxuu isticmaalayaa localhost
  static const bool _isProduction = true;

  // URL-ga backend-ka marka la isticmaalayo emulator
  static const String _localUrl = 'http://10.0.2.2:5000/api';

  // URL-ga backend-ka live (Render)
  static const String _prodUrl =
      'https://devblog-api-hsdf.onrender.com/api';

  // Base URL-ga la adeegsanayo
  static const String baseUrl =
      _isProduction ? _prodUrl : _localUrl;

  // Timeout dheer si server-ku waqti u helo
  static const Duration _timeout = Duration(seconds: 30);

  // Token-ka ka soo qaad kaydka telefoonka
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Diyaari headers-ka request kasta
  // Token-ka ku dar haddii uu jiro
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null)
        'Authorization': 'Bearer $token',
    };
  }

  // Login: email iyo password ku dir backend-ka
  Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs =
            await SharedPreferences.getInstance();

        // Token-ka kaydi si dambe loo isticmaalo
        await prefs.setString(
            'token', data['accessToken']);

        // User ID-ga kaydi
        await prefs.setString('userId', data['_id']);

        return {
          'success': true,
          'user': User.fromJson(data),
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Login failed',
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Server lama gaari karo',
      };
    }
  }

  // Register: samee user cusub
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password, {
    required String gender,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'gender': gender,
            }),
          )
          .timeout(_timeout);

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final prefs =
            await SharedPreferences.getInstance();

        // Token-ka kaydi
        await prefs.setString(
            'token', data['accessToken']);

        // User ID-ga kaydi
        await prefs.setString('userId', data['_id']);

        return {
          'success': true,
          'user': User.fromJson(data),
        };
      }

      return {
        'success': false,
        'message':
            data['message'] ?? 'Register failed',
      };
    } catch (_) {
      return {
        'success': false,
        'message': 'Server error',
      };
    }
  }

  // Soo qaad dhammaan posts-ka
  Future<List<Post>> getPosts() async {
    final response = await http
        .get(Uri.parse('$baseUrl/posts'))
        .timeout(_timeout);

    final data = jsonDecode(response.body);
    final List postsJson = data['posts'];

    // JSON u beddel List<Post>
    return postsJson
        .map((e) => Post.fromJson(e))
        .toList();
  }

  // Auto-login: hubi token-ka jira
  Future<User?> getMe() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/auth/me'),
            headers: await _getHeaders(),
          )
          .timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        return User.fromJson(
            jsonDecode(response.body));
      }
    } catch (_) {}

    return null;
  }
}
