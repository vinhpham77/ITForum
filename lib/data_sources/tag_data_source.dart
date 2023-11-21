import "package:cay_khe/models/tag.dart";

abstract class TagDataSource {
  Future<dynamic> get();
  Future<Tag?> getOne(String name);
  Future<void> add(Tag tag);
  Future<void> update(Tag tag);
  Future<void> delete(String id);
}