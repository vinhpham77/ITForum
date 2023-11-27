import 'dart:js_interop';

class BookMarkDto{
  final  String postId;
  final String username;

  BookMarkDto({
    required this.postId,
    required this.username
  });
  Map<String, dynamic> toJson() {
    return {
      'id': postId,
      'username': username
    };
  }
}

