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
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/create', data: postDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> getByUser() async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/by-user');
  }

  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('/$id');
  }

  Future<Response<dynamic>> getNumber() async {
    return dio.get('/number');
  }

  Future<Response<dynamic>> update(String id, PostDTO postDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/$id/update', data: postDTO.toJson());
  }
    Future<Response<dynamic>> getOneDetails(String id) async {
    return dio.get('/postDetails/$id');
  }
  Future<Response<dynamic>> getPostsSameAuthor(String authorName) async {
    return dio.get('/postsSameAuthor/$authorName');
  }
  Future<Response<dynamic>> checkVote(String postId, String userName) async {
    return dio.get('/checkVote', queryParameters: { 'id': postId,'userName': userName,});
  }

}
