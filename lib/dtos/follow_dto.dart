import 'package:flutter/foundation.dart';

class FollowDTO {
  final String followerId;
  final String followedId;
  final DateTime createdAt;

  FollowDTO({

    required this.followerId,
    required this.followedId,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
    return {
      'followerId': followerId,
      'followedId': followedId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}