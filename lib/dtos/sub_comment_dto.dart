class SubCommentDto {
  final String subCommentFatherId;

  final String username;

  final String content;

  SubCommentDto({
    this.subCommentFatherId = '',
    required this.username,
    required this.content
  });

  Map<String, dynamic> toJson() {
    return {
      'subCommentFatherId': subCommentFatherId,
      'username': username,
      'content': content,
    };
  }
}