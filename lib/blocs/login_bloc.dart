import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';



class LoginBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
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
        this.username = username;
        print(this.username);
        loginStatusController.sink.add(this.username);
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
