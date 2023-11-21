import 'dart:async';
import 'dart:html';
import 'dart:js';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/ui/common/utils.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';

class ChangePasswordBloc {
  StreamController _usernameController = new StreamController();
  StreamController _currentPassController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _repassController = new StreamController();
  StreamController<String> loginStatusController = StreamController();
  UserRepository _userRepository = new UserRepository();

  Stream get usernameStream => _usernameController.stream;
  Stream get curentPasStream => _currentPassController.stream;
  Stream get pasStream => _passController.stream;
  Stream get repassStream => _repassController.stream;
  Stream get getloginStatusController => loginStatusController.stream;

  String username = "";


late BuildContext context;

  RegisterBloc(BuildContext context) {
    this.context = context;
  }
  Future<bool> isValidInfo(String username, String currentpassword,
      String newpassword, String repassword) async {
        print(username);
    if (username == "" || !Validations.isValidUser(username)) {
   //  print(!Validations.isValidUser(username));
      _usernameController.sink.addError("Tài khoản phải lớn hơn 2 kí tự");
      return false;
    }
    _usernameController.sink.add("");
    if (!Validations.isValidPass(currentpassword)) {
       print(!Validations.isValidPass(currentpassword));
      _currentPassController.sink.addError("Mật khẩu phải lớn hơn 2 kí tự ");
      return false;
    }
    _currentPassController.sink.add("");

    if (!Validations.isValidPass(newpassword)) {
      _passController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return false;
    }
    _passController.sink.add("");

    if (!Validations.isValidRepass(newpassword, repassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return false;
    }
    _repassController.sink.add("");

    var future =  _userRepository.changePassUser(
        username, currentpassword, newpassword);
          future.then((response) {
      response.data;
      showTopRightSnackBar(
          context, 'Đổi mật khẩu thành công!', NotifyType.success);
      Navigator.of(context).pop();
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
