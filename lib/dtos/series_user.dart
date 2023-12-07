import 'package:cay_khe/models/user.dart';

class SeriesUser {
  String? id;
  String title;
  List<String> postIds;
  String content;
  int score;
  int commentCount;
  bool private;
  DateTime updatedAt;
  User user;

  SeriesUser(
      {required this.id,
      required this.title,
      required this.content,
      required this.postIds,
      required this.score,
      required this.commentCount,
      required this.private,
      required this.updatedAt,
      required this.user});

  factory SeriesUser.fromJson(Map<String, dynamic> json) {
    return SeriesUser(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      postIds: List<String>.from(json['postIds']),
      score: json['score'],
      commentCount: json['commentCount'],
      private: json['private'],
      updatedAt: DateTime.parse(json['updatedAt']),
      user: User.fromJson(json['user']),
    );
  }
}
