import 'dart:async';
import 'package:cay_khe/api_config.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../ui/common/utils/jwt_interceptor.dart';

class AuthRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}";

  AuthRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

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

  Future<Response<dynamic>> logoutUser(String refreshToken) async {
    dio = JwtInterceptor().addInterceptors(dio);
    if (refreshToken == null) {
      throw Exception('Chưa cung cấp refresh token');
    }
    return dio.get("/logout",
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Cookies': 'refresh_token=$refreshToken',
        }
      ),
    );
  }

}
