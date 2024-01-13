import "package:cay_khe/api_config.dart";
import 'package:cay_khe/models/bookmarkInfo.dart';
import 'package:cay_khe/ui/common/utils/jwt_interceptor.dart';
import 'package:dio/dio.dart';

class BookmarkRepository {
  late Dio dio;

  BookmarkRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.bookmarksEndpoint}"));
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> addBookmark(
      BookmarkInfo bookmarkInfo, String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/addPostBookmark',
        data: bookmarkInfo.toJson(), queryParameters: {'username': username});
  }

  Future<Response<dynamic>> unBookmark(String itemId) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.delete('/un-bookmark', queryParameters: {
      'itemId': itemId
    });
  }

  Future<Response<dynamic>> checkBookmark(
      String itemId, String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/checkBookmark', queryParameters: {
      'itemId': itemId,
      'username': username,
    });
  }

  Future<Response<dynamic>> getBookmarkByUsername(String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/byUsername', queryParameters: {'username': username});
  }

  Future<Response<dynamic>> getPostByUserName(
      {required String username,
      int? page,
      int? limit,
      bool isQuestion = false}) async {
    var optionalParams = page == null ? '' : 'page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    optionalParams += '&isQuestion=$isQuestion';
    return dio.get('/getPost?username=$username&$optionalParams');
  }

  Future<Response<dynamic>> getSeriesByUserName(
      {required String username, int? page, int? limit}) async {
    var optionalParams = page == null ? '' : 'page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    return dio.get('/getSeries?username=$username&$optionalParams');
  }
}
