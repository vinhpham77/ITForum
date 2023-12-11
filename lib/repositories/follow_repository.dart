import "package:cay_khe/api_config.dart";
import "package:cay_khe/dtos/follow_dto.dart";
import "package:cay_khe/ui/common/utils/index.dart";
import 'package:dio/dio.dart';

class FollowRepository {
  late Dio dio;

  FollowRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.followsEndpoint}"));
  }

  Future<Response<dynamic>> add(FollowDTO followDTO) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/create', data: followDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.delete(
      "/delete/$id",
    );
  }

  Future<Response<dynamic>> isFollowing(String followed) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/is-following/$followed');
  }

  Future<Response<dynamic>> follow(String followed) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/follow', data: followed);
  }

  Future<Response<dynamic>> unfollow(String followed) async {
    dio = JwtInterceptor(needToLogin: true).addInterceptors(dio);
    return dio.post('/unfollow', data: followed);
  }

  Future<Response<dynamic>> checkfollow(
      String follower, String followed) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/check', queryParameters: {
      'follower': follower,
      'followed': followed,
    });
  }

  Future<Response<dynamic>> totalFollower(String followedId) async {
    return dio.get('/totalFollower/$followedId');
  }
}
