

import "package:cay_khe/api_config.dart";
import 'package:cay_khe/dtos/bookmark_dto.dart';
import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:cay_khe/models/bookmarkInfo.dart';
import 'package:cay_khe/ui/common/utils/jwt_interceptor.dart';
import 'package:dio/dio.dart';

class BookmarkRepository {
  late Dio dio;

  BookmarkRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.bookmarksEndpoint}"));
  }

  // Future<Response<dynamic>> delete(String id) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> addBookmark(BookmarkInfo bookmarkInfo, String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/addPostBookmark', data:bookmarkInfo.toJson() ,queryParameters: {'username': username});
  }
  Future<Response<dynamic>> unBookmark(String itemId, String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/unPostBookmark', queryParameters: { 'itemId': itemId,'username': username,});
  }
  Future<Response<dynamic>> checkBookmark(String itemId, String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/checkBookmark', queryParameters: { 'itemId': itemId,'username': username,});
  }
  Future<Response<dynamic>> getBookmarkByUsername(String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/byUsername',queryParameters: { 'username': username});
  }


}
