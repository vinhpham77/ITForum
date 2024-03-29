

import 'package:cay_khe/models/user.dart';

class PostAggregation {
  String? id;
  String? title;
  List<String> tags;
  String? content;
  int score;
  int commentCount;
  bool private;
  DateTime? updatedAt;
  User? user;

  PostAggregation({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.score,
    required this.commentCount,
    required this.private,
    required this.updatedAt,
    required this.user
  });
  PostAggregation.empty()
      : id = null,
        title = '',
        content = '',
        tags = [],
        score = 0,
        commentCount=0,
        private = false,
        updatedAt = DateTime.now(),
        user = User.empty();


  factory PostAggregation.fromJson(Map<String, dynamic> json) {
    return PostAggregation(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: json['tags'] == null ? [] : json['tags'].cast<String>(),
      score: json['score'],
      commentCount: json['commentCount'],
      private: json['private'],
      updatedAt: json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      user: json['user'] == null ? null : User.fromJson(json['user']),
    );
  }

  PostAggregation copyWith({
    String? id,
    String? title,
    String? content,
    List<String>? tags,
    int? score,
    int? commentCount,
    bool? private,
    DateTime? updatedAt,
    User? user,
  }) {
    return PostAggregation(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      score: score ?? this.score,
      commentCount: commentCount ?? this.commentCount,
      private: private ?? this.private,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }

}