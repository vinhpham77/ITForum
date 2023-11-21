import "package:cay_khe/models/tag.dart";
import "package:dio/dio.dart";

abstract class TagDataSource {
  Future<Response<dynamic>> get();
  Future<Tag?> getOne(String name);
  Future<void> add(Tag tag);
  Future<void> update(Tag tag);
  Future<void> delete(String id);
}