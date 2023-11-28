import 'package:dio/dio.dart';

String getMessageFromException(dynamic err) {
  var error = err;

  if (err is DioException) {
    error = err;
  } else {
    return "Có lỗi xảy ra. Vui lòng thử lại sau!";
  }

  error as DioException;
  String message = "Có lỗi xảy ra. Vui lòng thử lại sau!";

  var errorMessage = error.response?.data;

  if (errorMessage is Map<String, dynamic>) {
    Map<String, dynamic> data = errorMessage;
    message = data.entries
        .map((entry) => "${entry.key}: ${entry.value}")
        .join("\n");
  } else if (errorMessage is String && errorMessage.isNotEmpty) {
    message = errorMessage;
  } else if (error.type == DioExceptionType.connectionTimeout) {
    message = "Không thể kết nối đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.connectionError) {
    message = "Lỗi kết nối đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.sendTimeout) {
    message = "Không thể gửi dữ liệu đến máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.receiveTimeout) {
    message = "Không thể nhận dữ liệu từ máy chủ. Vui lòng thử lại sau!";
  } else if (error.type == DioExceptionType.cancel) {
    message = "Yêu cầu đã bị hủy!";
  } else if (error.response?.statusCode == 401) {
    message = "Vui lòng đăng nhập!";
  } else if (error.response?.statusCode == 403) {
    message = "Bạn không thể thực hiện thao tác này! Vui lòng đăng nhập với tư cách khác!";
  } else if (error.response?.statusCode == 404) {
    message = "Không tìm thấy dữ liệu!";
  } else if (error.response?.statusCode == 500) {
    message = "Lỗi máy chủ!";
  } else if (error.response?.statusCode == 503) {
    message = "Máy chủ đang bảo trì!";
  } else if (error.response?.statusCode == 504) {
    message = "Không thể kết nối đến máy chủ. Vui lòng thử lại sau!";
  }

  return message;
}