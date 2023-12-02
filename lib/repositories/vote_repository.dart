import 'dart:js_interop';

import "package:cay_khe/api_config.dart";
import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:dio/dio.dart';

class VoteRepository {
   late Dio dio;

   VoteRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.votesEndpoint}"));
  }

  // Future<Response<dynamic>> delete(String id) {
  //   // TODO: implement delete
  //   throw UnimplementedError();
  // }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }
   Future<Response<dynamic>> getId(String postId) async {
     return dio.get('',queryParameters: { 'postId': postId});
   }

  Future<Response<dynamic>> checkVote(String postId, String username) async {


    return dio.get('/checkVote', queryParameters: { 'id': postId,'username': username,});
  }
  Future<Response<dynamic>> createVote(VoteDTO voteDTO) async {
    return dio.post('/createVote',data: voteDTO.toJson());

  }
  Future<Response<dynamic>> updateVote(String id, VoteDTO voteDTO) async {
    return dio.post('/updateVote/$id',data: voteDTO.toJson());

  }
   Future<Response<dynamic>> deleteVote(String id) async {
     return dio.delete('/deleteVote/$id');

   }
}
