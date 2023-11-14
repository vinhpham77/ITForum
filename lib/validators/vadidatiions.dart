class Validations 
{
  static bool isValidUser(String user){
    return user.length>2;
  }
  static bool isValidPass(String pass){
    return pass.length>2;
  }

}