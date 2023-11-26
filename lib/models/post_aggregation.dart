import 'package:cay_khe/dtos/user_dto.dart';

class PostAggregation {
  String? id;
  String title;
  List<String> tags;
  String content;
  int score;
  bool isPrivate;
  String createdBy;
  DateTime updatedAt;
  User user;

  PostAggregation({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.score,
    required this.isPrivate,
    required this.createdBy,
    required this.updatedAt,
    required this.user
  });

  factory PostAggregation.fromJson(Map<String, dynamic> json) {
    return PostAggregation(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      isPrivate: json['isPrivate'],
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }
}