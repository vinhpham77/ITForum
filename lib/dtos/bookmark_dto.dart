import 'dart:js_interop';

class BookMarkDto {
  final List<String> postIds;
  final String username;

  BookMarkDto({required this.postIds, required this.username});

  Map<String, dynamic> toJson() {
    return {'postIds': postIds, 'username': username};
  }
}
