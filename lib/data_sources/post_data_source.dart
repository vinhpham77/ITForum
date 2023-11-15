import "package:cay_khe/dtos/post_dto.dart";
import "package:cay_khe/models/post.dart";

abstract class PostDataSource {
  Future<List<Post>> get();
  Future<Post?> getOne(String id);
  Future<void> add(PostDTO postDTO);
  Future<void> update(String id, PostDTO postDTO);
  Future<void> delete(String id);
}