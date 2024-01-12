import '../models/user.dart';

class BookmarkItem {
  String? id;
  String? title;
  String? content;
  int score;
  int commentCount;
  bool private;
  DateTime? updatedAt;
  User? user;
  DateTime? bookmarkedAt;

  BookmarkItem(
      {required this.id,
      required this.title,
      required this.content,
      required this.score,
      required this.commentCount,
      required this.private,
      required this.updatedAt,
      required this.user,
      required this.bookmarkedAt});

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      score: json['score'],
      commentCount: json['commentCount'],
      private: json['private'],
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      user: json['user'] == null ? null : User.fromJson(json['user']),
      bookmarkedAt: json['bookmarkedAt'] == null
          ? null
          : DateTime.parse(json['bookmarkedAt']),
    );
  }
}

class PostBookmark extends BookmarkItem {
  List<String> tags;

  PostBookmark(
      {required super.id,
      required super.title,
      required super.content,
      required super.score,
      required super.commentCount,
      required super.private,
      required super.updatedAt,
      required super.user,
      required super.bookmarkedAt,
      required this.tags});

  factory PostBookmark.fromJson(Map<String, dynamic> json) {
    var superBookmarkItem = BookmarkItem.fromJson(json);
    return PostBookmark(
      id: superBookmarkItem.id,
      title: superBookmarkItem.title,
      content: superBookmarkItem.content,
      score: superBookmarkItem.score,
      commentCount: superBookmarkItem.commentCount,
      private: superBookmarkItem.private,
      updatedAt: superBookmarkItem.updatedAt,
      user: superBookmarkItem.user,
      bookmarkedAt: superBookmarkItem.bookmarkedAt,
      tags: json['tags'] == null ? [] : json['tags'].cast<String>(),
    );
  }
}

class SeriesBookmark extends BookmarkItem {
  List<String> postIds;

  SeriesBookmark(
      {required super.id,
      required super.title,
      required super.content,
      required super.score,
      required super.commentCount,
      required super.private,
      required super.updatedAt,
      required super.user,
      required super.bookmarkedAt,
      required this.postIds});

  factory SeriesBookmark.fromJson(Map<String, dynamic> json) {
    var superBookmarkItem = BookmarkItem.fromJson(json);
    return SeriesBookmark(
      id: superBookmarkItem.id,
      title: superBookmarkItem.title,
      content: superBookmarkItem.content,
      score: superBookmarkItem.score,
      commentCount: superBookmarkItem.commentCount,
      private: superBookmarkItem.private,
      updatedAt: superBookmarkItem.updatedAt,
      user: superBookmarkItem.user,
      bookmarkedAt: superBookmarkItem.bookmarkedAt,
      postIds: json['postIds'] == null ? [] : json['postIds'].cast<String>(),
    );
  }
}
