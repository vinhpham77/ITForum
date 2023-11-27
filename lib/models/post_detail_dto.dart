import 'dart:typed_data';

import 'package:cay_khe/models/user.dart';
import 'dart:convert';
class PostDetailDTO {
  final String id;
 final String title;
 final String content;
 final List<String> tags;
 final int score;
 final DateTime updatedAt;
 final User user;
 final bool private;

  PostDetailDTO({
    required this.id,
   required this.title,
   required this.content,
   required this.tags,
   required this.score,
   required this.updatedAt,
   required this.user,
   required this.private,
  });

  factory PostDetailDTO.fromJson(Map<String, dynamic> json) {
    return PostDetailDTO(
      id: json['id'],
     title: json['title'],
     content: json['content'],
     tags: List<String>.from(json['tags']),
     score: int.parse(json['score'].toString()), // Chuyển đổi từ chuỗi sang số nguyên
     updatedAt: DateTime.parse(json['updatedAt']),
     user: User.fromJson(json['user']),
     private: json['private'] ?? false, // Sử dụng giá trị mặc định nếu trường không tồn tại
    );
  }



// Sử dụng hàm parsePostDetailDTO để chuyển đổi response.data thành đối tượng PostDetailDTO
//   static  List<PostDetailDTO> parsePostDetailDTOList(String responseBody) {
//     List<dynamic> jsonDataList = json.decode(responseBody);
//     return jsonDataList.map((json) => PostDetailDTO.fromJson(json)).toList();
//   }
}