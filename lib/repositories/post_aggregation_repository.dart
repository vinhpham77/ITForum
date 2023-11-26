import 'package:dio/dio.dart';

import "package:cay_khe/api_config.dart";

class PostAggregatioRepository {
  late Dio dio;

  PostRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}"));
  }

  Future<Response<dynamic>> getSearch({
    String fieldSearch = "", String searchContent = "", String sort = "", String sortField = "", int page = 1
  }) async {
    return dio.get('/search?searchField=$fieldSearch&search=$searchContent&sort=$sort&sortField=$sortField&page=$page');
  }
}