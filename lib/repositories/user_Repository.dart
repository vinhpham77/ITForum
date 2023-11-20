import 'dart:async';
import 'dart:convert';
import 'package:cay_khe/api_config.dart';
import 'package:cay_khe/data_sources/user_data_source.dart';
import 'package:cay_khe/dtos/user_dto.dart';
import 'package:dio/dio.dart';

class UserRepository {
   late Dio dio;
  final String baseUrl = "${ApiConfig.baseUrl}/${ApiConfig.loginEndpoint}";
 
UserRepository() {
    dio = Dio(BaseOptions(baseUrl: baseUrl));
  }
  // Phương thức để thực hiện đăng nhập
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await dio.post(
        "/signin",
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (error) {
      return "Error connecting to the server";
    }
  }
  Future<String> registerUser(String username, String password,String email, String displayname) async {
    try {
      final response = await dio.post(
        "/signup",
        data: {
          'username': username,
          'password': password,
          'email':email,
          'displayName':displayname
        },
      );

      if (response.statusCode == 200) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (error) {
      return "Error connecting to the server";
    }
  }
   Future<String> changePassUser(String username, String currentpassword, String newPassword) async {
    try {
      final response = await dio.post(
        "/changepassword",
        data: {
          'username': username,
          'currentPassword': currentpassword,
          'newPassword':newPassword
        },
      );

      if (response.statusCode == 200) {
       
        return "Success";
      } else {
        return "Failed";
      }
    } catch (error) {
      return "Error connecting to the server";
    }
  }


Future<User?> forgotPassUser(String username) async {
  try {
    final response = await dio.post(
      "/forgetPassword",
      data: {'username': username},
    );

    if (response.statusCode == 200) {
      // Trả về trực tiếp dữ liệu từ phản hồi
      return User.fromJson(response.data);
    } else {
      // Xử lý mã trạng thái không phải 200
      print("Mã trạng thái không phải 200: ${response.statusCode}");
      return null;
    }
  } on DioException catch (error) {
    // Xử lý lỗi của Dio
    print("Lỗi Dio: $error");
    throw Exception("Lỗi server");
  } catch (error) {
    // Xử lý các lỗi khác
    print("Lỗi khác: $error");
    throw Exception("Lỗi server");
  }
}
  

   Future<String> resetPassUser(String username, String newPassword,String otp) async {
    try {
      final response = await dio.post(
        "/resetPassword",
        data: {
          'username': username,
          'newPassword':newPassword,
          'otp':otp
        },
      );

      if (response.statusCode == 204) {
        return "Success";
      } else {
        return "Failed";
      }
    } catch (error) {
      return "Error connecting to the server";
    }
  }
}
