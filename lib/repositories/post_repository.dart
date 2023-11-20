import "package:cay_khe/api_config.dart";
import "package:cay_khe/data_sources/post_data_source.dart";
import "package:cay_khe/dtos/post_dto.dart";
import 'package:dio/dio.dart';

class PostRepository implements PostDataSource {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}";

  PostRepository() {
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  }

  @override
  Future<Response<dynamic>> add(PostDTO postDTO) async {
    return dio.post('$baseUrl/create', data: postDTO.toJson());
  }

  @override
  Future<Response<dynamic>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Response<dynamic>> get() async {
    return dio.get(baseUrl);
  }

  @override
  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('$baseUrl/$id');
  }

  @override
  Future<Response<dynamic>> update(String id, PostDTO postDTO) async {
    return dio.put('$baseUrl/$id/update', data: postDTO.toJson());
  }
}
