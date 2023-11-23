import 'package:cay_khe/api_config.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:html' as html;

class JwtInterceptor extends Interceptor {
  BuildContext context = navigatorKey.currentContext!;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    String? refreshToken = prefs.getString('refreshToken');

    if (accessToken == null) {
      if (refreshToken == null) {
        navigateToLogin();
        return;
      } else {
        await refreshAccessToken(prefs, refreshToken);
        accessToken = prefs.getString('accessToken');
      }
    }

    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 412) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? refreshToken = prefs.getString('refreshToken');

      if (refreshToken == null) {
        navigateToLogin();
        return;
      }

      Dio dio = Dio();
      await refreshAccessToken(prefs, refreshToken);
      String accessToken = prefs.getString('accessToken')!;

      RequestOptions requestOptions = err.requestOptions;
      requestOptions.headers['Authorization'] = 'Bearer $accessToken';

      var response = await dio.request(requestOptions.path,
          options: convertToOptions(requestOptions));
      handler.resolve(response);
    } else {
      super.onError(err, handler);
    }
  }

  Options convertToOptions(RequestOptions requestOptions) {
    return Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      validateStatus: requestOptions.validateStatus,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
      extra: requestOptions.extra,
      followRedirects: requestOptions.followRedirects,
      maxRedirects: requestOptions.maxRedirects,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      listFormat: requestOptions.listFormat,
    );
  }

  Future<void> navigateToLogin() async {
    appRouter.go('/login');
  }

  Future<dynamic> refreshAccessToken(
      SharedPreferences prefs, String? refreshToken) async {
    Dio dio = Dio();

    try {
      dio.options.extra['withCredentials'] = true;
      html.document.cookie = 'refresh_token=$refreshToken';
      var response = await dio.get('${ApiConfig.baseUrl}/auth/refresh-token');
      return await prefs.setString('accessToken', response.data['token']);
    } catch (e) {
      if (e is DioException &&
          (e.response?.statusCode == 406 || e.response?.statusCode == 412)) {
        navigateToLogin();
      }
    }
  }
}
