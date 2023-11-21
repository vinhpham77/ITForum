import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

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

  late BuildContext context;

  RegisterBloc(BuildContext context) {
    this.context = context;
  }
  Future<bool> isValidInfo(String username, String password, String repassword,
      String email, String displayname) async {
    Future<bool> isValid;
    if (!Validations.isValidDisplayName(displayname)) {
      _fullnameController.sink.addError("Tên người dùng phải lớn hơn 1 kí tự");
      return Future<bool>.value(false);
    }
    _fullnameController.sink.add("");
    if (!Validations.isValidEmail(email)) {
      _emailController.sink.addError("Email không hợp lệ");
      return Future<bool>.value(false);
    }
    _emailController.sink.add("");

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
    if (!Validations.isValidRepass(password, repassword)) {
      _rePasswordController.sink
          .addError("Mật khẩu không khớp với mật khẩu trên");
      return Future<bool>.value(false);
    }
    _rePasswordController.sink.add("");
    var future =
        _userRepository.registerUser(username, password, email, displayname);
    isValid = future.then((response) {
      print(response.data);
      print("adsd");
      showTopRightSnackBar(context, 'Đăng ký thành công!', NotifyType.success);
      return true;
    }).catchError((error) {
      String message = getMessageFromException(error);
      print(message);
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
