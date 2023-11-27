import 'package:dio/dio.dart';

import "package:cay_khe/api_config.dart";

class PostAggregatioRepository {
  late Dio dio;

  PostAggregatioRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}"));
  }

  Future<Response<dynamic>> getSearch({
    required String fieldSearch,
    required String searchContent,
    required String sort,
    required String sortField,
    required String page
  }) async {
    return dio.get('/search?searchField=$fieldSearch&search=$searchContent&sort=$sort&sortField=$sortField&page=$page');
  }
}