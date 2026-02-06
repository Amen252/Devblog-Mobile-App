import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';

// ApiService: Fasalkan wuxuu mas'uul ka yahay dhammaan xiriirka u dhexeeya App-ka iyo Server-ka (Backend).
// Waxaan halkan ku qoreynaa functions-ka HTTP-ga (GET, POST, PUT, DELETE).
class ApiService {
  // Ciwaanka asalka ah ee Backend-ka. 
  // 1: Local Emulator (Android) -> 'http://10.0.2.2:5000/api'
  // 2: Production (Render) -> 'https://YOUR-RENDER-URL.onrender.com/api'
  
  static const bool _isProduction = true; // Enabled production mode for APK
  
  static const String _localUrl = 'http://10.0.2.2:5000/api';
  static const String _prodUrl = 'https://devblog-api-hsdf.onrender.com/api'; // Live Render URL
  
  static const String baseUrl = _isProduction ? _prodUrl : _localUrl;
  static const Duration _timeout = Duration(seconds: 30); // Increased timeout for Render cold starts

  // Shaqadan waxay SharedPreferences ka soo akhrisaa 'Token'-ka si loo ogaado user-ka.
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Token-ku waa furaha gelitaanka API-ga.
  }

  // function-kan wuxuu diyaarinayaa Header-ka codsi kasta (Request).
  // Wuxuu raacinayaa Token-ka 'Authorization' si server-ku noo aqoonsado.
  Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json', // Xogta aan direyno waa JSON.
      if (token != null) 'Authorization': 'Bearer $token', // Token-ka raaci haddii uu jiro.
    };
  }

  // Shaqada Gelitaanka (Login): Waxay hubisaa email-ka iyo erayga sirta ah.
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(_timeout);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Haddii uu guuleysto, xogta muhiimka ah ayaa lagu kaydiyaa SharedPreferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['accessToken']);
        await prefs.setString('userId', data['_id']);
        return {'success': true, 'user': User.fromJson(data)};
      }
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    } catch (e) {
      return {'success': false, 'message': 'Khalad ayaa ka dhacay xiriirka server-ka.'};
    }
  }

  // Shaqada Is-diiwaangelinta (Register): Waxay abuurtaa akoon cusub.
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
      return {'success': false, 'message': 'Khalad ayaa ka dhacay xiriirka server-ka.'};
    }
  }

  // Shaqadan waxay cusubaysaa xogta shakhsiga ah ee isticmaalaha.
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

  // Shaqada Logout-ka: Waxay tirtirtaa xogta kaydsan ee qofka.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
  }

  // Shaqadan waxay soo akhrisaa dhammaan qoraallada (Posts) backend-ka yaala.
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts')).timeout(_timeout);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> postsJson = data['posts'];
        // Koodhkan wuxuu xogta JSON u beddelayaa 'List of Post objects'.
        return postsJson.map((json) => Post.fromJson(json)).toList();
      }
      throw Exception('Failed to load posts');
    } catch (e) {
      throw Exception('Server-ka lama heli karo. Fadlan hubi internet-kaaga.');
    }
  }

  // Shaqada abuurista qoraal cusub.
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

  // Shaqada lagu beddelo ama lagu saxo qoraal hore u jiray.
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

  // Shaqada lagu tirtiro qoraal gaar ah.
  Future<void> deletePost(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: await _getHeaders(),
    ).timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to delete post');
    }
  }

  // getMe: Shaqadan waxaa loo isticmaalaa 'Auto-login'.
  // Marka app-ka la furo, waxay xogta user-ka ka soo akhrisaa token-ka hadda jira.
  Future<User?> getMe() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/me'),
        headers: await _getHeaders(),
      ).timeout(const Duration(seconds: 2));

      if (response.statusCode == 200) {
        // Haddii token-ku weli shaqeynayo, User object soo celi.
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Auto-login connection failed: $e'); // Cilad dhacday xilliga xiriirka.
    }
    return null; // Haddii uu token-ku dhacay ama server-ku ciladoobo.
  }
}

