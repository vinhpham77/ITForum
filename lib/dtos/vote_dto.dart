class VoteDTO {
  final String postId;
  final String? username;
  final bool type;
  final DateTime updatedAt;
  // Thêm các trường khác tương ứng với dữ liệu user từ API

  VoteDTO({
    required this.postId,
    required this.username,
    required this.type,
    required this.updatedAt,
  });

  // Phương thức tạo user từ JSON
  factory VoteDTO.fromJson(Map<String, dynamic> json) {
    return VoteDTO(
      postId: json['postId'],
      username: json['username'],
      type: json['type'],
      updatedAt: DateTime.parse(json['updatedAt'])
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'username': username??'',
      'type':type,
      'updatedAt':updatedAt.toIso8601String()
    };
  }
}
