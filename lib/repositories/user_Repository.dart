import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: "http://localhost:8888/api"));

  UserRepository();

  // Phương thức để thực hiện đăng nhập
  Future<String> loginUser(String username, String password) async {
    try {
      final response = await _dio.post(
        "/auth/signin",
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
      print("No connection");
      return "Error connecting to the server";
    }
  }
}
