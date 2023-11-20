import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';



class LoginBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  static String usernameGlobal = "";
  Future<bool> isValidInfo(String username, String password) async {
    if (!Validations.isValidUser(username)) {
      _userController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return false;
    }
    _userController.sink.add("");

    if (!Validations.isValidPass(password)) {
      _passController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự");
      return false;
    }
    _passController.sink.add("");
    String result = await _userRepository.loginUser(username, password);
    if (result == 'Success')
    {
        usernameGlobal = username;
        loginStatusController.sink.add(usernameGlobal);
    return true;
    }
    else{
      loginStatusController.sink.addError(result);
      return false;
    }
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}
