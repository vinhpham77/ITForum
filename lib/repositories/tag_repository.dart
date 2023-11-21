import "package:cay_khe/models/tag.dart";
import 'package:dio/dio.dart';
import "package:cay_khe/api_config.dart";
import "package:cay_khe/data_sources/tag_data_source.dart";


class TagRepository implements TagDataSource {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.tagsEndpoint}";

  TagRepository() {
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  }

  @override
  Future<void> add(Tag tag) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<dynamic> get() async {
    final response = await dio.get(baseUrl);

    if (response.statusCode == 200) {
      Iterable list = response.data;
      return list.map((tag) => Tag.fromJson(tag)).toList();
    } else {
      throw Exception('Failed to load tags');
    }
  }

  @override
  Future<Tag?> getOne(String name) async {
    // final response = await dio.get('/$name');
    // if (response.statusCode == 200) {
    //   return Tag.fromJson(response.data);
    // } else {
    //   throw Exception('Failed to load book');
    // }
    throw UnimplementedError();
  }

  @override
  Future<void> update(Tag tag) {
    // TODO: implement update
    throw UnimplementedError();
  }


}