import 'package:cay_khe/dtos/limit_page.dart';
import 'package:dio/dio.dart';

import "package:cay_khe/api_config.dart";

class PostAggregationRepository {
  late Dio dio;

  PostAggregationRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}"));
  }

  Future<Response<dynamic>> getSearch({
    required String fieldSearch,
    required String searchContent,
    required String sort,
    required String sortField,
    required String page,
    int? limit
  }) async {
    return dio.get('/search?searchField=$fieldSearch&search=$searchContent&sort=$sort&sortField=$sortField&page=$page&limit=${limit ?? limitPage}');
  }
}