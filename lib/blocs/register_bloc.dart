import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';

class RegisterBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _fullnameController = new StreamController();
  StreamController _rePasswordController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get fullnameStream => _fullnameController.stream;
  Stream get rePasswordController => _rePasswordController.stream;
  Stream get emailController => _emailController.stream;

  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";

  Future<bool> isValidInfo(String username, String password, String repassword,
      String email, String displayname) async {
    if (!Validations.isValidDisplayName(displayname)) {
      _fullnameController.sink.addError("Tên người dùng phải lớn hơn 1 kí tự");
      return false;
    }
    _fullnameController.sink.add("");
    if (!Validations.isValidEmail(email)) {
      _emailController.sink.addError("Email không hợp lệ");
      return false;
    }
    _emailController.sink.add("");
  
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
    if(!Validations.isValidRepass(password, repassword)){
      _rePasswordController.sink.addError("Mật khẩu không khớp với mật khẩu trên");
      return false;
    }
    _rePasswordController.sink.add("");
    String result = await _userRepository.registerUser(
        username, password, email, displayname);
    if (result == 'Success') {
      // this.username = username;
      // loginStatusController.sink.add(this.username);
      return true;
    } else {
      //loginStatusController.sink.addError(result);
      return false;
    }
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}
