class UserDTO {
  final String username;
  final String email;
  // Thêm các trường khác tương ứng với dữ liệu user từ API

  UserDTO({required this.username, required this.email});
  
  // Phương thức tạo user từ JSON
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
      username: json['username'],
      email: json['email'],
      // Các trường khác tương ứng với dữ liệu user từ API
    );
  }
}
