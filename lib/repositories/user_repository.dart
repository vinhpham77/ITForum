import 'dart:async';

import 'package:cay_khe/api_config.dart';
import 'package:dio/dio.dart';

class UserRepository {
  late Dio _dio;
  final String _baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.usersEndpoint}";

  UserRepository() {
    _dio = Dio(BaseOptions(baseUrl: _baseUrl));
  }

  Future<Response<dynamic>> get(String username) async {
    return _dio.get("/$username");
  }

  Future<Response<dynamic>> getFollows({
    required String username,
    required int page,
    required int limit,
    required bool isFollowed,
  }) async {
    String object = isFollowed ? "followers" : "followings";
    return _dio.get(
      "/$username/$object",
      queryParameters: {
        "page": page,
        "limit": limit,
      },
    );
  }

  Future<Response<dynamic>> getStats(String username) async {
    return _dio.get("/stats/$username");
  }
}
