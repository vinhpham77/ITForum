import 'package:cay_khe/models/user.dart';

class SubCommentAggreGate {
  String id;
  String username;
  String content;
  DateTime updatedAt;
  int left;
  int right;
  User user;

  SubCommentAggreGate({
    required this.id,
    required this.username,
    required this.content,
    required this.updatedAt,
    required this.left,
    required this.right,
    required this.user
  });

  factory SubCommentAggreGate.fromJson(Map<String, dynamic> json) {
    return SubCommentAggreGate(
      id: json['id'],
      username: json['username'],
      content: json['content'],
      updatedAt: DateTime.parse(json['updatedAt']),
      left: json['left'],
      right: json['right'],
      user: User.fromJson(json['user']),
    );
  }
}