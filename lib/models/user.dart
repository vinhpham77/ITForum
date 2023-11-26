class User {
   String id;

     String username;

     String password;

     String email;

     bool gender;

     DateTime birthdate;

     String avatarUrl;

     String bio;

     String role;

     String displayName;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.gender,
    required this.birthdate,
    required this.avatarUrl,
    required this.bio,
    required this.role,
    required this.displayName
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      gender: json['gender'],
      birthdate: DateTime.parse(json['birthdate']),
      avatarUrl: json['avatarUrl'],
      bio: json['bio'],
      role: json['role'],
      displayName: json['displayName'],
    );
  }
   Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'gender': gender,
      'birthdate': birthdate.toIso8601String(),
      'avatarUrl': avatarUrl,
      'bio': bio,
      'role': role,
      'displayName': displayName,
    };
  }
}
