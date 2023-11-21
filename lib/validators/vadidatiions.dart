class Validations {
  // Kiểm tra độ dài tối thiểu của tên người dùng
  static bool isValidUsername(String username) {
    return username.trim().length >2;
  }

  // Kiểm tra độ dài tối thiểu của mật khẩu
  static bool isValidPassword(String password) {
    return password.trim().length >2;
  }

  // Kiểm tra hai mật khẩu có giống nhau không
  static bool arePasswordsEqual(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // Kiểm tra định dạng hợp lệ của địa chỉ email
  static bool isValidEmail(String email) {
    RegExp emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
        caseSensitive: false,
        unicode: true,
    );
    return emailRegex.hasMatch(email.trim());
  }

  // Kiểm tra độ dài tối thiểu của tên hiển thị
  static bool isValidDisplayName(String displayName) {
    return displayName.trim().length >2;
  }
}
