import 'package:dio/dio.dart';

String getMessageFromException(Exception err) {
  DioException error = err as DioException;
  String message = '';

  if (error.response?.data is Map<String, dynamic>) {
    Map<String, dynamic> data = error.response?.data;
    message = data.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join("\n");
  } else if (error.response?.data is String) {
    message = error.response?.data;
  } else {
    message = "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

  return message;
}