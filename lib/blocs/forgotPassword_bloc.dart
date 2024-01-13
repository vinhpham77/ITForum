import 'dart:async';
import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/auth_repository.dart';
import 'package:cay_khe/repositories/user_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

class ForgotPasswordBloc {
  final StreamController _emailController = StreamController();

  StreamController<String> loginStatusController = StreamController();
  final UserRepository _userRepository = UserRepository();
  final StreamController _userController = StreamController();
  final StreamController _usernameController = StreamController();
  Stream get user => _userController.stream;
  Stream get usernameStream => _usernameController.stream;
  Stream get emailStream => _emailController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
  String username = "";
  static String requestname = "";
  late BuildContext context;

  ForgotPasswordBloc(this.context);
  Future<bool> isValidInfo(String username) {
    Future<bool> isvalid;
    if (!Validations.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return Future<bool>.value(false);
    }
    _usernameController.sink.add("");

    var future = _userRepository.forgotPassUser(username);
    isvalid = future.then((response) {
      requestname=response.data;
      // showTopRightSnackBar(
      //     context, 'Đến trang đổi mật khẩu!', NotifyType.success);
      return Future<bool>.value(true);
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isvalid;
  }

  void dispose() {
    _emailController.close();
  }
}
