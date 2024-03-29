import 'dart:async';

import 'package:cay_khe/dtos/notify_type.dart';
import 'package:cay_khe/repositories/auth_repository.dart';
import 'package:cay_khe/ui/common/utils/message_from_exception.dart';
import 'package:cay_khe/ui/widgets/notification.dart';
import 'package:cay_khe/validators/vadidatiions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/common/utils/jwt_interceptor.dart';

class LoginBloc {
  final StreamController _userController = StreamController();
  final StreamController _passController = StreamController();
  StreamController<String> loginStatusController = StreamController();
  final AuthRepository _userRepository = AuthRepository();

  Stream get userStream => _userController.stream;

  Stream get passStream => _passController.stream;

  Stream get getloginStatusController => loginStatusController.stream;
  static String usernameGlobal = "";
  late BuildContext context;

  LoginBloc(this.context);

  Future<bool> isValidInfo(String username, String password) {
    Future<bool> isValid;
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
    var future = _userRepository.loginUser(username, password);

    isValid = future.then((response) {
      usernameGlobal = username;
      loginStatusController.sink.add(usernameGlobal);

      return SharedPreferences.getInstance().then((prefs) {
        prefs.setString('refreshToken', response.data['token']);
        return JwtInterceptor()
            .refreshAccessToken(prefs, false)
            .then((value) => value != null);
      });
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
