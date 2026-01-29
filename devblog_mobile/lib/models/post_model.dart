class Post {
  final String id;
  final String title;
  final String content;
  final String authorId;
  final String authorName;
  final String category;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.authorId,
    required this.authorName,
    required this.category,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      authorId: json['author'] is Map ? json['author']['_id'] : json['author'],
      authorName: json['author'] is Map ? json['author']['name'] ?? 'Unknown' : 'Unknown',
      category: json['category'] ?? 'General',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'category': category,
    };
  }
}
