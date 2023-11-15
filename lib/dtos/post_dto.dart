class PostDTO {
  final String title;
  final String content;
  final List<String> tags;
  final bool isPrivate;
  final String createdBy;
  final DateTime? updatedBy;

  PostDTO(this.updatedBy, {
    required this.title,
    required this.content,
    required this.tags,
    required this.isPrivate,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'tags': tags,
      'isPrivate': isPrivate,
      'createdBy': createdBy,
      'updatedAt': updatedBy?.toIso8601String(),
    };
  }
}
