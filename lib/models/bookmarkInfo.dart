class BookmarkInfo {
  final String itemId;
  final String type;

  BookmarkInfo({
    required this.itemId,
    required this.type,
  });

  factory BookmarkInfo.fromJson(Map<String, dynamic> json) {
    return BookmarkInfo(
        itemId: json['itemId'],
        type: json['type']);
  }
  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'type': type,
    };
  }

// Sử dụng hàm parsePostDetailDTO để chuyển đổi response.data thành đối tượng PostDetailDTO
//   static  List<PostDetailDTO> parsePostDetailDTOList(String responseBody) {
//     List<dynamic> jsonDataList = json.decode(responseBody);
//     return jsonDataList.map((json) => PostDetailDTO.fromJson(json)).toList();
//   }
}
