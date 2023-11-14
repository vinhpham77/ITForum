class Tag {
  String id;
  String name;
  String description;

  Tag({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}
