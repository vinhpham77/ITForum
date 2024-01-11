import "package:cay_khe/api_config.dart";
import "package:cay_khe/dtos/post_dto.dart";
import 'package:dio/dio.dart';
import 'package:cay_khe/ui/common/utils/jwt_interceptor.dart';

class PostRepository {
  late Dio dio;

  PostRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}"));
  }

  Future<Response<dynamic>> add(PostDTO postDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/create', data: postDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.delete('/$id/delete');
  }

  Future<Response<dynamic>> get(
      String? username, String? page, int? limit) async {
    return dio.get('');
  }

  Future<Response<dynamic>> getByUser(String username,
      {int? page, int? limit, bool isQuestion = false}) async {
    dio = JwtInterceptor().addInterceptors(dio);
    var optionalParams = page == null ? '' : '&page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    optionalParams += isQuestion ? '&isQuestion=$isQuestion' : '';
    return dio.get('/by-user?username=$username$optionalParams');
  }

  Future<Response<dynamic>> getOne(String id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/$id');
  }

  Future<Response<dynamic>> getNumber() async {
    return dio.get('/number');
  }

  Future<Response<dynamic>> update(String id, PostDTO postDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.put('/$id/update', data: postDTO.toJson());
  }

  Future<Response<dynamic>> getOneDetails(String id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/postDetails/$id');
  }

  Future<Response<dynamic>> getPostsSameAuthor(String authorName , String postId) async {
    return dio.get('/postsSameAuthor/$authorName',queryParameters: {'postId':postId});
  }
  Future<Response<dynamic>> updateScore(String idPost, int score) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio
        .put('/updateScore', queryParameters: {'id': idPost, 'score': score});
  }
  Future<Response<dynamic>> totalPost(String username) async {
   // dio = JwtInterceptor().addInterceptors(dio);
    return dio
        .get('/totalPost/$username');
  }
}
