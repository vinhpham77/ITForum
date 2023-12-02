class Post {
  String id;
  String title;
  List<String> tags;
  String content;
  int score;
  bool isPrivate;
  String createdBy;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.score,
    required this.isPrivate,
    required this.createdBy,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      isPrivate: json['isPrivate'],
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdBy':createdBy,
      'score':score,
      'title': title,
      'content': content,
      'tags': tags,
      'isPrivate': isPrivate,
      'updatedAt': updatedAt
    };
  }
}
