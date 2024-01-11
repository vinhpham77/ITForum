class UserStats {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String? avatarUrl;
  final String role;
  final int postCount;
  final int seriesCount;
  final int followerCount;

  UserStats({
    required this.id,
    required this.username,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    required this.role,
    required this.postCount,
    required this.seriesCount,
    required this.followerCount,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
      role: json['role'],
      postCount: json['postCount'],
      seriesCount: json['seriesCount'],
      followerCount: json['followerCount'],
    );
  }
}