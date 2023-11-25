class SeriesDTO {
  String title;
  String content;
  bool isPrivate;

  SeriesDTO({
    required this.title,
    required this.content,
    required this.isPrivate,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'isPrivate': isPrivate,
    };
  }
}