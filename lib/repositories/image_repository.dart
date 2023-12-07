import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../api_config.dart';
import '../ui/common/utils/jwt_interceptor.dart';

class ImageRepository {
  late Dio dio;

  ImageRepository() {
    dio = Dio(BaseOptions(
        baseUrl: "${ApiConfig.baseUrl}/${ApiConfig.imagesEndpoint}"));
  }

  Future<Response<dynamic>> upload(XFile file) async {
    String fileName = file.name;
    List<int> fileBytes = await file.readAsBytes();
    String fileContents = base64Encode(fileBytes);

    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(fileBytes, filename: fileName),
    });
    dio = JwtInterceptor().addInterceptors(dio);
    return dio.post('/upload', data: formData);
  }
}