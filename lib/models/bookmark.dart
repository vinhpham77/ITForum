
import 'package:cay_khe/models/bookmarkInfo.dart';

class Bookmark {
  final String id;
  final List<BookmarkInfo> bookmarkInfoList;
  final String username;

  Bookmark({
    required this.id,
    required this.bookmarkInfoList,
    required this.username,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
        id: json['id'],
        bookmarkInfoList: List<BookmarkInfo>.from(json['bookmarkInfoList']),
        username: json['username']);
  }
}
