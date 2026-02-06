import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

// PostProvider: Waxay maamushaa dhammaan xogta qoraallada (Posts) ee app-ka.
class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Post> _posts = []; // Liiska qoraallada backend-ka laga soo akhriyey
  final Set<String> _bookmarkedIds = {}; // Liiska ID-yada la keydiyey
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  List<Post> get bookmarkedPosts => _posts.where((p) => _bookmarkedIds.contains(p.id)).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }

  // Shaqadan waxay soo celisaa dhammaan qoraallada yaala Backend-ka.
  Future<void> fetchPosts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _apiService.getPosts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shaqada abuurista qoraal cusub iyo ku darista liiska hadda muuqda.
  Future<void> createPost(String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newPost = await _apiService.createPost(title, content, category);
      _posts.insert(0, newPost); // Qoraalka cusub waxaa la geliyaa meesha ugu sarreysa
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shaqadan waxay cusubaysaa qoraal hore u jiray.
  Future<void> updatePost(String id, String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedPost = await _apiService.updatePost(id, title, content, category);
      final index = _posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _posts[index] = updatedPost; // Liiska ayaa lagu cusubaynayaa qoraalka la saxay
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Shaqada tirtirista qoraal.
  Future<void> deletePost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((p) => p.id == id); // Isla markiiba waxaa laga saarayaa liiska UI-ga
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

