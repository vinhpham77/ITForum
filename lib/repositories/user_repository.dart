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
}
