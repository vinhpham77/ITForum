import 'dart:async';
import 'dart:js';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

class ResetPasswordBloc {
  StreamController _usernameController = new StreamController();
  StreamController _otpController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _repassController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get usernameStream => _usernameController.stream;
  Stream get otpStream => _otpController.stream;
  Stream get pasStream => _passController.stream;
  Stream get repassStream => _repassController.stream;
  Stream get getloginStatusController => loginStatusController.stream;
late BuildContext context;
ResetPasswordBloc (BuildContext context){
  this.context=context;
}
  String username = "";

  Future<bool> isValidInfo(String username, String otp, String newpassword,
      String repassword) async {
    if (!Validations.isValidUser(username)) {
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }
    _usernameController.sink.add("");
    if (!Validations.isValidPass(otp)) {
      _otpController.sink.addError("Mật khẩu không hợp lệ");
      return false;
    }
    _otpController.sink.add("");
    if (!Validations.isValidPass(newpassword)) {
      _passController.sink.addError("Mật khẩu mới không hợp lệ");
      return false;
    }
    _passController.sink.add("");

    if (!Validations.isValidRepass(newpassword, repassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return false;
    }
    _repassController.sink.add("");

    var future =
        _userRepository.resetPassUser(username, newpassword, otp);
   
     future.then((response) {
      response.data;
      showTopRightSnackBar(
          context, 'Đổi mật khẩu thành công!', NotifyType.success);
      return true;
    }).catchError((error) {
      String message = getMessageFromException(error);
      showTopRightSnackBar(context, message, NotifyType.error);
      return false;
    });
    return false;
   
      }

  void dispose() {
    _passController.close();
    _repassController.close();
  }
}
