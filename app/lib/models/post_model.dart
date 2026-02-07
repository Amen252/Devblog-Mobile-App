// Abuurista class lagu magacaabo Post
class Post {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String authorGender;
  final String category;
  final DateTime createdAt;

// Constructor-ka class-ka Post
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.authorGender,
    required this.category,
    required this.createdAt,
  });


  // Factory method oo JSON uga beddelaya Post object
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      authorId: json['author'] is Map ? json['author']['_id'] : json['author'],
      authorName: json['author'] is Map ? json['author']['name'] ?? 'Unknown' : 'Unknown',
      authorGender: json['author'] is Map ? json['author']['gender'] ?? 'male' : 'male',
      category: json['category'] ?? 'General',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
// Method u beddelaya Post object JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
    };
  }
}
