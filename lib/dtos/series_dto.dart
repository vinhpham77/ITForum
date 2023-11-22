class SeriesDTO {
  String title;
  String content;
  List<String> postIds;
  bool isPrivate;
  int score;

  SeriesDTO({
    required this.title,
    required this.content,
    required this.postIds,
    required this.isPrivate,
    required this.score,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'postIds': postIds,
      'isPrivate': isPrivate,
      'score': score,
    };
  }
}