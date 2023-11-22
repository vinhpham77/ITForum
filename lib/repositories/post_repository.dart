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
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: JwtInterceptor().onRequest,
        onError: JwtInterceptor().onError)
    );
    return dio.post('/create', data: postDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('/$id');
  }

  Future<Response<dynamic>> update(String id, PostDTO postDTO) async {
    return dio.put('/$id/update', data: postDTO.toJson());
  }
}
