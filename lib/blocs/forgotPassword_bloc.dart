import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/dtos/user_dto.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  static String requestname = "";
  late BuildContext context;

  ForgotPasswordBloc(BuildContext context) {
    this.context = context;
  }
  Future<User>? isValidInfo(String username) {
    Future<User>? isvalid;
    if (!Validations.isValidUser(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return Future<User>.value(null);
    }
    _usernameController.sink.add("");

    var future = _userRepository.forgotPassUser(username);
    isvalid = future.then((response) {
      response.data;
      showTopRightSnackBar(
          context, 'Đến trang đổi mật khẩu!', NotifyType.success);
        GoRouter.of(context).go("/resetPass"); 
      return Future<User>.value(response.data);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<User>.value(null);
    }) as Future<User>?;
    return isvalid;
  }

  void dispose() {
    _emailController.close();
  }
}
