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
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      score: json['score'] is int ? json['score'] : 0,
      commentCount: json['commentCount'] ?? 0,
      isPrivate: json['isPrivate'] ?? false,
      createdBy: json['createdBy'] ?? '',
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : DateTime.now(),
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

  Post copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tags,
    int? score,
    int? commentCount,
    bool? isPrivate,
    String? createdBy,
    DateTime? updatedAt,
  }) {
    return Post(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      isPrivate: isPrivate ?? this.isPrivate,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

}
