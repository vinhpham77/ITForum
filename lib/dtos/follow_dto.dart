
class FollowDTO {
  final String follower;
  final String followed;
  final DateTime createdAt;

  FollowDTO({

    required this.follower,
    required this.followed,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
    return {
      'follower': follower,
      'followed': followed,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}