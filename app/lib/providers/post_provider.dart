import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';

// PostProvider: Waxay mas'uulka ka tahay maamulista dhammaan qoraallada (Posts) ee app-ka.
// Waxay isticmaashaa ChangeNotifier si ay UI-ga ugu sheegto marka xogta isbeddesho.
class PostProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  // Liiska dhammaan qoraallada laga soo akhriyey backend-ka
  List<Post> _posts = []; 
  
  // Set-kan wuxuu kaydiyaa ID-yada qoraallada uu user-ku 'Bookmark' gareeyey
  final Set<String> _bookmarkedIds = {}; 
  
  // Maqaamka rarka (Loading) - haddii ay xogta soo rarantahay iyo haddii kale
  bool _isLoading = false;
  
  // Meeshan waxaa lagu kaydiyaa haddii uu khalad (Error) dhaco xilliga API-ga lala xiriirayo
  String? _error;

  // Getters: Si qaybaha kale ee app-ku ay u akhriyaan xogta iyadoon si toos ah loo taaban karin
  List<Post> get posts => _posts;
  
  // Filter-kan wuxuu soo saaraa qoraallada la keydiyey oo kaliya
  List<Post> get bookmarkedPosts => _posts.where((p) => _bookmarkedIds.contains(p.id)).toList();
  
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Hubinta in qoraal gaar ah la 'Save' gareeyey iyo in kale
  bool isBookmarked(String id) => _bookmarkedIds.contains(id);

  // Shaqadan waxay qoraalka ku dartaa ama ka saartaa Bookmarks-ka
  void toggleBookmark(String id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id); // Haddii uu ku jiray, ka saar
    } else {
      _bookmarkedIds.add(id);    // Haddii uusan ku jirin, ku dar
    }
    notifyListeners(); // UI-ga u sheeg inuu dib isku build-gareeyo
  }

  // fetchPosts: Shaqadan waxay qoraallada ugu dambeeyey ka soo akhrisaa Backend-ka
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

  // createPost: Shaqada lagu abuurayo qoraal cusub laguna dirayo API-ga
  Future<void> createPost(String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newPost = await _apiService.createPost(title, content, category);
      _posts.insert(0, newPost); // Qoraalka cusub geli meesha ugu sarreysa (Top)
    } finally {
      _isLoading = false;
      notifyListeners(); // UI-ga dib u cusubaysii
    }
  }

  // updatePost: Shaqadan waxay beddelaysaa (Edit) qoraal hore u jiray
  Future<void> updatePost(String id, String title, String content, String category) async {
    _isLoading = true;
    notifyListeners();

    try {
      final updatedPost = await _apiService.updatePost(id, title, content, category);
      final index = _posts.indexWhere((p) => p.id == id);
      if (index != -1) {
        _posts[index] = updatedPost; // Liiska ku beddel qoraalka cusub ee la soo saxay
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // deletePost: Shaqada tirtirista qoraalka
  Future<void> deletePost(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiService.deletePost(id);
      _posts.removeWhere((p) => p.id == id); // Isla markiiba ka saar liiska si UI-ga u muuqdo isbeddelka
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

