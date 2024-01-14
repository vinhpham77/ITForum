import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/auth_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class ResetPasswordBloc {
  final StreamController _usernameController = StreamController();
  final StreamController _otpController = StreamController();
  final StreamController _passController = StreamController();
  final StreamController _repassController = StreamController();
  StreamController<String> loginStatusController = StreamController();
  final UserRepository _userRepository = UserRepository();

  Stream get usernameStream => _usernameController.stream;

  Stream get otpStream => _otpController.stream;

  Stream get pasStream => _passController.stream;

  Stream get repassStream => _repassController.stream;

  Stream get getloginStatusController => loginStatusController.stream;
  late BuildContext context;

  ResetPasswordBloc(this.context);

  String username = "";

  Future<bool> isValidInfo(String username, String otp, String newpassword,
      String repassword) async {
    Future<bool> isvalid;
    if (!Validations.isValidUsername(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return Future<bool>.value(false);
    }
    _usernameController.sink.add("");
    if (!Validations.isValidPassword(otp)) {
      _otpController.sink.addError("Mật khẩu không hợp lệ");
      return Future<bool>.value(false);
    }
    _otpController.sink.add("");
    if (!Validations.isValidPassword(newpassword)) {
      _passController.sink.addError("Mật khẩu mới không hợp lệ");
      return Future<bool>.value(false);
    }
    _passController.sink.add("");

    if (!Validations.arePasswordsEqual(newpassword, repassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return Future<bool>.value(false);
    }
    _repassController.sink.add("");

    var future = _userRepository.resetPassUser(username, newpassword, otp);

    isvalid = future.then((response) {
      response.data;
      showTopRightSnackBar(
          context, 'Đổi mật khẩu thành công!', NotifyType.success);
      return Future<bool>.value(true);
    }).catchError((error) {
      print("loi r");
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return Future<bool>.value(false);
    });
    return isvalid;
  }

  void dispose() {
    _passController.close();
    _repassController.close();
  }
}
