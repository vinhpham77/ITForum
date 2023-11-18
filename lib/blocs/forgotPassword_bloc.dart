import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';



class ForgotPasswordBloc {
  StreamController _emailController = new StreamController();
  
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  
  Stream get emailStream => _emailController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";

  Future<bool> isValidInfo(String email) async {
    if (!Validations.isValidUser(username)) {
      _emailController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }

    
    String result = await _userRepository.loginUser(email,"");
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
    _emailController.close();
  }
}
