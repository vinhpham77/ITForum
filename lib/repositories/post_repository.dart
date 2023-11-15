import "package:cay_khe/dtos/post_dto.dart";
import "package:cay_khe/models/post.dart";
import 'package:dio/dio.dart';
import "package:cay_khe/api_config.dart";
import "package:cay_khe/data_sources/post_data_source.dart";


class PostRepository implements PostDataSource {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.postsEndpoint}";

  PostRepository() {
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  }

  @override
  Future<void> add(PostDTO postDTO) async {
    final response = await dio.post('$baseUrl/create', data: postDTO.toJson());
    if (response.statusCode == 201) {
      return Future.value();
    } else {
      throw Exception('Failed to create post');
    }
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> get() async {
    final response = await dio.get(baseUrl);

    if (response.statusCode == 200) {
      Iterable list = response.data;
      return list.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Post?> getOne(String id) async {
    final response = await dio.get('$baseUrl/$id');
    if (response.statusCode == 200) {
      return Post.fromJson(response.data);
    } else {
      throw Exception('Failed to get post');
    }
  }

  @override
  Future<void> update(Post post) {
    // TODO: implement update
    throw UnimplementedError();
  }


}