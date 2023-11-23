class Series {
  String? id;
  String title;
  String content;
  List<String> postIds;
  int score;
  bool isPrivate;
  String createdBy;
  DateTime updatedAt;

  Series({
    required this.id,
    required this.title,
    required this.content,
    required this.postIds,
    required this.score,
    required this.isPrivate,
    required this.createdBy,
    required this.updatedAt,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      postIds: List<String>.from(json['postIds']),
      score: json['score'],
      isPrivate: json['isPrivate'],
      createdBy: json['createdBy'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
