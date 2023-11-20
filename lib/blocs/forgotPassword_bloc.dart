import 'dart:async';

import 'package:cay_khe/dtos/user_dto.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';

class ForgotPasswordBloc {
  StreamController _emailController = new StreamController();

  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();
  StreamController _userController = new StreamController();
  StreamController _usernameController = new StreamController();
  Stream get user => _userController.stream;
  Stream get usernameStream => _usernameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";

  Future<User?> isValidInfo(String username) async {
    if (!Validations.isValidUser(username)) {
      _emailController.sink.addError("Tài khoản không hợp lệ");
      return null;
    }

    try {
      var result = await _userRepository.forgotPassUser(username);

      if (result != null) {
        _userController.sink.add(result.username);
        print(result.username);
        return result;
      } else {
        _emailController.sink
            .addError("Thông tin không hợp lệ hoặc có lỗi xảy ra");
        return null;
      }
    } catch (error) {
      // Xử lý lỗi nếu có
      print("Lỗi xảy ra: $error");
      _emailController.sink.addError("Lỗi xảy ra");
      return null;
    }
  }

  void dispose() {
    _emailController.close();
  }
}
