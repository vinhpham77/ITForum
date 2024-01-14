class UserDTO {
  final String email;
  final bool? gender;
  final DateTime? birthdate;
  final String? avatarUrl;
  final String? bio;
  final String displayName;

  UserDTO({required this.email, required this.gender, required this.birthdate, required this.avatarUrl, required this.bio, required this.displayName});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'gender': gender,
      'birthdate': birthdate?.toIso8601String(),
      'bio': bio,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
    };
  }
}
