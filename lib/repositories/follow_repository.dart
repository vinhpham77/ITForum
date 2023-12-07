import "package:cay_khe/api_config.dart";
import "package:cay_khe/dtos/follow_dto.dart";
import "package:cay_khe/dtos/series_dto.dart";
import "package:cay_khe/ui/common/utils/index.dart";
import 'package:dio/dio.dart';

class FollowRepository {
  late Dio dio;

  FollowRepository() {
    dio = Dio(BaseOptions(baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.followsEndpoint}"));
  }
  Future<Response<dynamic>> add(FollowDTO followDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/create', data: followDTO.toJson());
  }
  Future<Response<dynamic>> delete(String id) {
   return dio.delete("/delete/$id",);
  }
  Future<Response<dynamic>> checkfollow(String followerId,String followedId) async {
    return dio.get('/check', queryParameters: { 'followerId': followerId,'followedId': followedId,});
  }

}
