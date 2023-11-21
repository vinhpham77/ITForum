import 'package:dio/dio.dart';

String getMessageFromException(dynamic err) {

  var error = err;

  if (err is DioException) {
    error = err;
  } else {
    return "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

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