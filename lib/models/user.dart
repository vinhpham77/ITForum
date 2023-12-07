
class User {
  String id;

  String username;

  String email;

  bool? gender;
  //
  DateTime? birthdate;
  //
  String? avatarUrl;
  //
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
  User.empty()
      : id = '',
        username = '',
        email = '',
        gender = null,
        birthdate = null,
        avatarUrl = null,
        bio = null,
        role = '',
        displayName = '';


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      gender: json['gender'],
      birthdate: json['birthdate'] != null ? DateTime.parse(json['birthdate']) : null,
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      role: json['role'],
      displayName: json['displayName'],
    );
  }

}