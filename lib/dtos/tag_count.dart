class TagCount {
  final String tag;
  final int count;

  TagCount({required this.tag, required this.count});

  TagCount.fromJson(Map<String, dynamic> json)
      : tag = json['tag'],
        count = json['count'];
  
  TagCount copyWith({
    String? tag,
    int? count,
  }) {
    return TagCount(
      tag: tag ?? this.tag,
      count: count ?? this.count,
    );
  }
}