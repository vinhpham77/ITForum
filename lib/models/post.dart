class Post {
  String id;
  String title;
  List<String> tags;
  String content;
  int score;
  bool isPrivate;
  int commentCount;
  String createdBy;
  DateTime updatedAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.score,
    required this.commentCount,
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
      commentCount: json['commentCount'],
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
      'commentCount': commentCount,
      'isPrivate': isPrivate,
      'updatedAt': updatedAt
    };
  }
}
