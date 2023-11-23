import 'package:dio/dio.dart';

String getMessageFromException(dynamic err) {

  var error = err;

  if (err is DioException) {
    error = err;
  } else {
    return "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

  String message = "Có lỗi xảy ra. Vui lòng thử lại sau!";

  var errorMessage = error.response?.data;

  if (errorMessage is Map<String, dynamic>) {
    Map<String, dynamic> data = errorMessage;
    message = data.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join("\n");
  } else if (errorMessage is String && errorMessage.isNotEmpty) {
    message = errorMessage;
  }

  return message;
}