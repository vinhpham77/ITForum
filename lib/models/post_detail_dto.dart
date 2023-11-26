import 'package:cay_khe/dtos/user_dto.dart';

class PostDetailDTO {
    String id;

     String title;

     String content;

     List<String> tags;

     int score;

      bool isPrivate;

     DateTime updatedAt;

     List<User> users;


  PostDetailDTO({
    required this.id,
    required this.title,
    required this.content,
    required this.tags,
    required this.isPrivate,
    required this.score,
    required this.updatedAt,
    required this.users
  });
 factory PostDetailDTO.fromJson(Map<String, dynamic> json) {
    return PostDetailDTO(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      tags: List<String>.from(json['tags']),
      score: json['score'],
      isPrivate: json['isPrivate'],
      updatedAt: DateTime.parse(json['updatedAt']),
      // Users are assumed to be contained in a 'users' field in the JSON
      users: (json['users'] as List<dynamic>?)
          ?.map((userJson) => User.fromJson(userJson))
          .toList() ?? [],
    );
  }

  }
