import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await _apiService.getPosts();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newPost = await _apiService.createPost(title, content, category);
      _posts.insert(0, newPost);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updatePost(String id, String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedPost = await _apiService.updatePost(id, title, content, category);
      final index = _posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((p) => p.id == id);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
