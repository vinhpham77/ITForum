class User {
  final String username;
  final String email;
  // Thêm các trường khác tương ứng với dữ liệu user từ API

  User({required this.username, required this.email});
  
  // Phương thức tạo user từ JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      // Các trường khác tương ứng với dữ liệu user từ API
    );
  }
}
