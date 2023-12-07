import 'package:flutter/foundation.dart';

class Follow {
  String id;
  String followerId;
  String followedId;
  DateTime createdAt;

  Follow({
    required this.id,
    required this.followerId,
    required this.followedId,
    required this.createdAt,
  });

  Follow.empty()
      : id = '',
        followedId = '',
        followerId = '',
        createdAt = DateTime.now();

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
        id: json['id'] ?? '',
        followerId: json['followerId'] ?? '',
        followedId: json['followedId'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now());
  }
}
