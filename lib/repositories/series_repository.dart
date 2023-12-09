import "package:cay_khe/api_config.dart";
import "package:cay_khe/dtos/series_dto.dart";
import "package:cay_khe/ui/common/utils/index.dart";
import 'package:dio/dio.dart';

class SeriesRepository {
  late Dio dio;

  SeriesRepository() {
    dio = Dio(BaseOptions(baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.seriesEndpoint}"));
  }

  Future<Response<dynamic>> add(SeriesDTO seriesDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/create', data: seriesDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.delete('/$id/delete');
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> getByUser(String username,
      {int? page, int? limit}) async {
    dio = JwtInterceptor().addInterceptors(dio);
    var optionalParams = page == null ? '' : '&page=$page';
    optionalParams += limit == null ? '' : '&limit=$limit';
    return dio.get('/by-user?username=$username$optionalParams');
  }

  Future<Response<dynamic>> getOne(String id) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.get('/$id');
  }


  Future<Response<dynamic>> update(String id, SeriesDTO seriesDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/$id/update', data: seriesDTO.toJson());
  }
  Future<Response<dynamic>> updateScore(String idPost, int  score) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/updateScore', queryParameters: { 'id': idPost,'score':score });
  }
  Future<Response<dynamic>> totalSeries(String username) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio
        .get('/totalSeries/$username');
  }
}
