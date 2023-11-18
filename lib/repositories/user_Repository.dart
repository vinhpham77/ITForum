import 'dart:async';
import 'dart:convert';
import 'package:cay_khe/api_config.dart';
import 'package:cay_khe/data_sources/user_data_source.dart';
import 'package:dio/dio.dart';

class UserRepository  extends UserDataSource{
   late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}";
 
UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }
  // Phương thức để thực hiện đăng nhập
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await dio.post(
        "/signin",
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (error) {
      return "Error connecting to the server";
    }
  }
}
