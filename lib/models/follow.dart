class Follow {
  String id;
  String follower;
  String followed;
  DateTime createdAt;

  Follow({
    required this.id,
    required this.follower,
    required this.followed,
    required this.createdAt,
  });

  Follow.empty()
      : id = '',
        followed = '',
        follower = '',
        createdAt = DateTime.now();

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
        id: json['id'] ?? '',
        follower: json['follower'] ?? '',
        followed: json['followed'] ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now());
  }
}
