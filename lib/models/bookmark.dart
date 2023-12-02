import 'dart:typed_data';

import 'package:cay_khe/models/user.dart';
import 'dart:convert';

class Bookmark {
  final String id;
  final List<String> postIds;
  final String username;

  Bookmark({
    required this.id,
    required this.postIds,
    required this.username,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
        id: json['id'],
        postIds: List<String>.from(json['postIds']),
        username: json['username']);
  }

// Sử dụng hàm parsePostDetailDTO để chuyển đổi response.data thành đối tượng PostDetailDTO
//   static  List<PostDetailDTO> parsePostDetailDTOList(String responseBody) {
//     List<dynamic> jsonDataList = json.decode(responseBody);
//     return jsonDataList.map((json) => PostDetailDTO.fromJson(json)).toList();
//   }
}
