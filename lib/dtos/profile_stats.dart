class ProfileStats {
  int postCount;
  int questionCount;
  int seriesCount;
  int followingCount;
  int followerCount;
  int bookmarkCount;

  ProfileStats({
    required this.postCount,
    required this.questionCount,
    required this.seriesCount,
    required this.followingCount,
    required this.followerCount,
    required this.bookmarkCount,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) {
    return ProfileStats(
      postCount: json['postCount'],
      questionCount: json['questionCount'],
      seriesCount: json['seriesCount'],
      followingCount: json['followingCount'],
      followerCount: json['followerCount'],
      bookmarkCount: json['bookmarkCount'],
    );
  }

  // copyWith
  ProfileStats copyWith({
    int? postCount,
    int? questionCount,
    int? seriesCount,
    int? followingCount,
    int? followerCount,
    int? bookmarkCount,
  }) {
    return ProfileStats(
      postCount: postCount ?? this.postCount,
      questionCount: questionCount ?? this.questionCount,
      seriesCount: seriesCount ?? this.seriesCount,
      followingCount: followingCount ?? this.followingCount,
      followerCount: followerCount ?? this.followerCount,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
    );
  }
}