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
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get() async {
    return dio.get('');
  }

  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('/$id');
  }

  Future<Response<dynamic>> update(String id, SeriesDTO seriesDTO) async {
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.put('/$id/update', data: seriesDTO.toJson());
  }
}
