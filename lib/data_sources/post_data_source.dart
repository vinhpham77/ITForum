import "package:cay_khe/dtos/post_dto.dart";
import "package:dio/dio.dart";

abstract class PostDataSource {
  Future<Response<dynamic>> get();
  Future<Response<dynamic>> getOne(String id);
  Future<Response<dynamic>> add(PostDTO postDTO);
  Future<Response<dynamic>> update(String id, PostDTO postDTO);
  Future<Response<dynamic>> delete(String id);
}