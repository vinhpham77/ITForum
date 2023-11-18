import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';



class ChangePasswordBloc {
  StreamController _curentPassController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _repassController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get pasStream => _passController.stream;
  Stream get repassStream => _repassController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";

  Future<bool> isValidInfo(String curentPass, String password, String repassword) async {
    if (!Validations.isValidUser(username)) {
      _passController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }

    if (!Validations.isValidPass(repassword)) {
      _passController.sink.addError("Mật khẩu không hợp lệ");
      return false;
    }
    String result = await _userRepository.loginUser(password, repassword);
    if (result == 'Success')
    {
        this.username = username;
        loginStatusController.sink.add(this.username);
    return true;
    }
    else{
      loginStatusController.sink.addError(result);
      return false;
    }

    
  }

  void dispose() {
    _passController.close();
    _repassController.close();
  }
}
