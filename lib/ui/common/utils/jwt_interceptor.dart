import 'dart:convert';
import 'dart:html' as html;

import 'package:cay_khe/api_config.dart';
import 'package:cay_khe/ui/router.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../dtos/jwt_payload.dart';

class JwtInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var prefs = await SharedPreferences.getInstance();
    String? accessToken =
        prefs.getString('accessToken') ?? await refreshAccessToken(prefs, true);

    options.headers['Authorization'] = 'Bearer $accessToken';
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 412) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Dio dio = Dio();
      String accessToken = await refreshAccessToken(prefs, true);

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
      SharedPreferences? prefs, bool needToNavigate) async {
    print('1');
    prefs ??= await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) {
      if (needToNavigate) {
        navigateToLogin();
      }
      return;
    }

    try {
      Dio dio = Dio();
      dio.options.extra['withCredentials'] = true;
      html.document.cookie = 'refresh_token=$refreshToken';
      var response = await dio.get('${ApiConfig.baseUrl}/auth/refresh-token');
      parseJwt(response.data['token'], needToNavigate: true);
      bool success =
          await prefs.setString('accessToken', response.data['token']);
      return success ? response.data['token'] : null;
    } catch (e) {
      if (e is DioException &&
          (e.response?.statusCode == 406 || e.response?.statusCode == 412)) {
        navigateToLogin();
      }
    }
  }

  parseJwt(String? token,
      {bool needToRefresh = false, bool needToNavigate = false}) {
    if (needToRefresh) {
      refreshAccessToken(null, needToNavigate);
      return;
    }

    if (token == null) {
      return;
    }

    var payloadMap = validateJwtAndReturnPayload(token);

    if (payloadMap == null) {
      if (needToNavigate) {
        navigateToLogin();
      }
      return;
    }

    JwtPayload.role = payloadMap['role'] as String;
    JwtPayload.displayName = payloadMap['displayName'] as String;
    JwtPayload.sub = payloadMap['sub'] as String;
    JwtPayload.iat = payloadMap['iat'] as int;
    JwtPayload.exp = payloadMap['exp'] as int;
    JwtPayload.avatarUrl = payloadMap['avatarUrl'] as String?;
  }

  Map<String, dynamic>? validateJwtAndReturnPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      return null;
    }

    final exp = payloadMap['exp'] as int;
    final iat = payloadMap['iat'] as int;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (now <= exp && now >= iat) {
      return payloadMap;
    }
    return null;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Chuỗi ký tự base64 không hợp lệ!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Dio addInterceptors(Dio dio) {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: JwtInterceptor().onRequest,
        onError: JwtInterceptor().onError));

    return dio;
  }
}
