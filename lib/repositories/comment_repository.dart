import "package:cay_khe/api_config.dart";
import 'package:cay_khe/dtos/bookmark_dto.dart';
import 'package:cay_khe/dtos/sub_comment_dto.dart';
import 'package:cay_khe/dtos/vote_dto.dart';
import 'package:dio/dio.dart';

import '../ui/common/utils/jwt_interceptor.dart';

class CommentRepository{
  late Dio dio;

  CommentRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.commentsEndpoint}"));
  }

  Future<Response<dynamic>> add(String postId, SubCommentDto subCommentDto) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/$postId/add', data: subCommentDto.toJson());
  }

  Future<Response<dynamic>> getSubComment(String postId, String subId) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/$postId/get?subId=$subId');
  }

  Future<Response<dynamic>> deleteSubComment(String postId, String subId) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/$postId/$subId/delete');
  }

  Future<Response<dynamic>> updateSubComment(String postId, String subId, SubCommentDto subCommentDto) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/$postId/$subId/update', data: subCommentDto.toJson());
  }
}
