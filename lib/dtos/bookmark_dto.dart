

import 'package:cay_khe/models/bookmarkInfo.dart';

class BookMarkDto {
  final List<BookmarkInfo> bookmarkInfoList;
  final String username;

  BookMarkDto({required this.bookmarkInfoList, required this.username});

  Map<String, dynamic> toJson() {
    return {'bookmarkInfoList': bookmarkInfoList, 'username': username};
  }
}
