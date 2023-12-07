

import 'package:cay_khe/models/user.dart';

class PostAggregation {
  String? id;
  String title;
  List<String> tags;
  String content;
  int score;
  bool private;
  DateTime updatedAt;
  User user;

  PostAggregation({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.score,
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
        private = false,
        updatedAt = DateTime.now(),
        user = User.empty();


  factory PostAggregation.fromJson(Map<String, dynamic> json) {
    return PostAggregation(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      private: json['private'],
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }
}