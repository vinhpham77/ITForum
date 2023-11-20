import 'dart:async';

import 'package:cay_khe/repositories/user_Repository.dart';
import 'package:cay_khe/validators/vadidatiions.dart';



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

  Future<bool> isValidInfo(String username, String currentpassword, String newpassword,String repassword) async {
    if (username==null&& username=='') {
      print(username);
      _usernameController.sink.addError("Tài khoản không hợp lệ");
      return false;
    }

    if (!Validations.isValidPass(currentpassword)) {
      _currentPassController.sink.addError("Mật khẩu không hợp lệ");
      return false;
    }
     if (!Validations.isValidPass(newpassword)) {
      _passController.sink.addError("Mật khẩu mới không hợp lệ");
      return false;
    }
     if (!Validations.isValidrePass(newpassword, repassword)) {
      _repassController.sink.addError("Mật khẩu phải khớp với mật khẩu ở trên");
      return false;
    }

    String result = await _userRepository.changePassUser( username, currentpassword, newpassword);
    if (result == 'Success')
    {
       // this.username = username;
       // loginStatusController.sink.add(this.username);
    return true;
    }
    else{
      loginStatusController.sink.addError(result);
      return false;
    }

    
  }

  void dispose() {
    _passController.close();
    _repassController.close();
  }
}
