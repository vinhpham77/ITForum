import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

class RegisterBloc {
  final StreamController _userController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _fullnameController = StreamController();
  final StreamController _rePasswordController = StreamController();
  final StreamController _emailController = StreamController();
  StreamController<String> loginStatusController = StreamController();
  final UserRepository _userRepository = UserRepository();

  Stream get userStream => _userController.stream;
  Stream get passStream => _passController.stream;
  Stream get fullnameStream => _fullnameController.stream;
  Stream get rePasswordController => _rePasswordController.stream;
  Stream get emailController => _emailController.stream;

  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";

  late BuildContext context;

  RegisterBloc(this.context);
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

    if (!Validations.isValidUsername(username)) {
      _userController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _userController.sink.add("");

    if (!Validations.isValidPassword(password)) {
      _passController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự");
      return Future<bool>.value(false);
    }
    _passController.sink.add("");
    if (!Validations.arePasswordsEqual(password, repassword)) {
      _rePasswordController.sink
          .addError("Mật khẩu không khớp với mật khẩu trên");
      return Future<bool>.value(false);
    }
    _rePasswordController.sink.add("");
    var future =
        _userRepository.registerUser(username, password, email, displayname);
    isValid = future.then((response) {
      showTopRightSnackBar(context, 'Đăng ký thành công!', NotifyType.success);
      return Future<bool>.value(true);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isValid;
  }

  void dispose() {
    _userController.close();
    _passController.close();
  }
}
