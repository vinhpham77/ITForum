
class User {
  String id;

  String username;

  String email;

  bool? gender;

  DateTime? birthdate;

  String? avatarUrl;

  String? bio;
  String role;

  String displayName;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.gender,
    required this.birthdate,
    required this.avatarUrl,
    required this.bio,
    required this.role,
    required this.displayName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      role: json['role'],
      displayName: json['displayName'],
    );
  }
}