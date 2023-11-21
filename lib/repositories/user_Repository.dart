import 'dart:async';
import 'dart:convert';
import 'package:cay_khe/api_config.dart';
import 'package:cay_khe/dtos/user_dto.dart';
import 'package:dio/dio.dart';

class UserRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }
  // Phương thức để thực hiện đăng nhập
  Future<Response<dynamic>> loginUser(String username, String password) async {
    return dio.post("/signin", data: {
      'username': username,
      'password': password,
    });
  }

  Future<Response<dynamic>> registerUser(String username, String password,
      String email, String displayname) async {
    return dio.post(
      "/signup",
      data: {
        'username': username,
        'password': password,
        'email': email,
        'displayName': displayname
      },
    );
  }

  Future<Response<dynamic>> changePassUser(
      String username, String currentpassword, String newPassword) async {
    return dio.post(
      "/changePassword",
      data: {
        'username': username,
        'currentPassword': currentpassword,
        'newPassword': newPassword
      },
    );
  }

  Future<Response<dynamic>> forgotPassUser(String username) async {
    return dio.post(
      "/forgetPassword",
      data: {'username': username},
    );
  }

  Future<Response<dynamic>> resetPassUser(
      String username, String newPassword, String otp) async {
    return dio.post(
      "/resetPassword",
      data: {'username': username, 'newPassword': newPassword, 'otp': otp},
    );
  }
}
