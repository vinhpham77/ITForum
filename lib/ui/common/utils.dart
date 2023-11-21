import 'package:dio/dio.dart';

String getMessageFromException(DioException err) {
  String message = '';

  if (err.response?.data is Map<String, dynamic>) {
    Map<String, dynamic> data = err.response?.data;
    message = data.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join("\n");
  } else if (err.response?.data is String) {
    message = err.response?.data;
  } else {
    message = "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

  return message;
}