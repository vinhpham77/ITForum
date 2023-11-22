import "package:cay_khe/api_config.dart";
import "package:cay_khe/dtos/series_dto.dart";
import 'package:dio/dio.dart';

class SeriesRepository {
  late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.seriesEndpoint}";

  SeriesRepository() {
    dio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));
  }

  Future<Response<dynamic>> add(SeriesDTO seriesDTO) async {
    return dio.post('/create', data: seriesDTO.toJson());
  }

  Future<Response<dynamic>> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<Response<dynamic>> get() async {
    return dio.get(baseUrl);
  }

  Future<Response<dynamic>> getOne(String id) async {
    return dio.get('/$id');
  }

  Future<Response<dynamic>> update(String id, SeriesDTO seriesDTO) async {
    return dio.put('/$id/update', data: seriesDTO.toJson());
  }
}
