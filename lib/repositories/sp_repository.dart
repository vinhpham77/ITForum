
import 'package:dio/dio.dart';

import "package:cay_khe/api_config.dart";

class SpRepository {
  late Dio dio;

  SpRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.seriesEndpoint}"));
  }
  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('/detail/$id');
  }

}