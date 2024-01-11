import 'dart:async';

import 'package:cay_khe/api_config.dart';
import 'package:dio/dio.dart';

class UserRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }

  Future<Response<dynamic>> getUser(String username) async {
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
}
