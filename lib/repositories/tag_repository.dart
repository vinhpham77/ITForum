import "package:cay_khe/models/tag.dart";
import 'package:dio/dio.dart';
import "package:cay_khe/api_config.dart";

class TagRepository {
  late Dio dio;

  TagRepository() {
    dio = Dio(
        BaseOptions(baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.tagsEndpoint}"));
  }

  Future<void> add(Tag tag) {
    // TODO: implement add
    throw UnimplementedError();
  }

  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Tag?> getOne(String name) async {
    throw UnimplementedError();
  }

  Future<void> update(Tag tag) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
