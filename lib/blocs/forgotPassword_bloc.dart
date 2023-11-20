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
static String requestname="";
  Future<User?> isValidInfo(String username) async {
    if (!Validations.isValidUser(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return null;
    }
      _usernameController.sink.add("");

      var result = await _userRepository.forgotPassUser(username);

      if (result != null) {
        requestname=result.username;
        _usernameController.sink.add(result.username);
        return result;
      } 
      return null;
    } 

     void dispose() {
    _emailController.close();
  } 
  }

  
