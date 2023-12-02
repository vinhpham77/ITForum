

import "package:cay_khe/api_config.dart";
import 'package:cay_khe/dtos/bookmark_dto.dart';
import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:dio/dio.dart';

class BookmarkRepository {
  late Dio dio;

  BookmarkRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.bookmarksEndpoint}"));
  }

  // Future<Response<dynamic>> delete(String id) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> addBookmark(String postId, String username) async {

    return dio.post('/addPostBookmark', queryParameters: { 'postId': postId,'username': username,});
  }
  Future<Response<dynamic>> unBookmark(String postId, String username) async {

    return dio.delete('/unPostBookmark', queryParameters: { 'postId': postId,'username': username,});
  }
  Future<Response<dynamic>> checkBookmark(String postId, String username) async {

    return dio.get('/checkBookmark', queryParameters: { 'postId': postId,'username': username,});
  }
  Future<Response<dynamic>> createVote(BookMarkDto bookMarkDto) async {
    return dio.post('/createVote',data: bookMarkDto.toJson());
  }
  Future<Response<dynamic>> updateVote(String id, VoteDTO voteDTO) async {
    return dio.post('/updateVote/$id',data: voteDTO.toJson());

  }

  Future<Response<dynamic>> getBookmarkByUsername(String username) async {
    return dio.get('/byUsername',queryParameters: { 'username': username});
  }


}
