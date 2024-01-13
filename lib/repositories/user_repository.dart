import 'dart:async';

import 'package:cay_khe/api_config.dart';
import 'package:dio/dio.dart';

import '../ui/common/utils/jwt_interceptor.dart';

class UserRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Response<dynamic>> getUser(String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get("/$username");
  }
  Future<Response<dynamic>> getFollows({
    required String username,
    required int page,
    required int limit,
    required bool isFollowed,
  }) async {
    String object = isFollowed ? "followers" : "followings";
    return dio.get(
      "/$username/$object",
      queryParameters: {
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Response<dynamic>> getStats(String username) async {
    return dio.get("/stats/$username");
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
