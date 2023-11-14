import 'dart:async';

import 'package:comunityshare/src/repository/userRepository.dart';
import 'package:comunityshare/src/validators/vadidatiions.dart';

class LoginBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  String username = "";

  Future<bool> isValidInfo(String username, String password) async {
    if (!Validations.isValidUser(username)) {
      _userController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }

    if (!Validations.isValidPass(password)) {
      _passController.sink.addError("Mật khẩu không hợp lệ");
      return false;
    }
    String result = await _userRepository.loginUser(username, password);
    if (result == 'Success')
    {
        username = username;
  _loginStatusController.sink.add(username);
    return true;
    }
    else{
      _loginStatusController.sink.addError(result);
      return false;
    }

    
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}
