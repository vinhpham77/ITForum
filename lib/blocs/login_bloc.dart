import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

class LoginBloc {
  StreamController _userController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  static String usernameGlobal = "";
  late BuildContext context;

  LoginBloc(BuildContext context) {
    this.context = context;
  }

  Future<bool> isValidInfo(String username, String password) {
    Future<bool> isValid;
    if (!Validations.isValidUser(username)) {
      _userController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }

    _userController.sink.add("");

    if (!Validations.isValidPass(password)) {
      _passController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _passController.sink.add("");
    var future = _userRepository.loginUser(username, password);

    isValid = future.then((response) {
      usernameGlobal = username;
      loginStatusController.sink.add(usernameGlobal);

      response.data;
      showTopRightSnackBar(
          context, 'Đăng nhập thành công!', NotifyType.success);

      return true;
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return false;
    });
    return isValid;
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}
