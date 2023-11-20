import 'dart:js_util';

class Validations 
{
  static bool isValidUser(String user){
    return user.length>2;
  }
  static bool isValidPass(String pass){
    return pass.length>2;
  }
  static bool isValidRepass(String pass,String repass){
    return pass==repass;
  }
  static bool isValidEmail(String email){
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    return regex.hasMatch(email);
  }
  static bool isValidDisplayName(String name){
    return name.length>2;
  }

}