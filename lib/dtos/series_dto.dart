class SeriesDTO {
  String title;
  String content;
  bool isPrivate;
  List<String> postIds;

  SeriesDTO({
    required this.title,
    required this.content,
    required this.isPrivate,
    required this.postIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'isPrivate': isPrivate,
      'postIds': postIds,
    };
  }
}