import 'dart:convert';
import 'dart:io';

import 'package:byaparlekha/components/extra_componenets.dart';
import 'package:byaparlekha/config/api/apiUrl.dart';
import 'package:byaparlekha/config/routes/routes.dart';
import 'package:byaparlekha/services/sharedPreferenceService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HttpService {
  static BuildContext? context;

  final Dio _dio = Dio()
    ..interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        String headers = "";
        options.headers.forEach((key, value) {
          headers += "| $key: $value";
        });
        debugPrint('--------------------------------');
        debugPrint('Request Path ${options.path}');
        debugPrint('''[DIO] Request: ${options.method} ${options.uri.toString()}
        Options: ${(options.data is FormData) ? (options.data as FormData).fields : options.data}
        Headers:\n$headers''');
        debugPrint('--------------------------------');
        handler.next(options);
      },
      onError: (e, handler) {
        debugPrint('--------------------------------');
        debugPrint('Request Path ${e.requestOptions.path}');
        debugPrint("[DIO] Response [code ${e.response?.statusCode}]");
        debugPrint('--------------------------------');
        debugPrint((e.response?.data ?? e.message).toString());
        debugPrint('--------------------------------');
        if (e.response?.statusCode == 401) {
          _logoutUser();
        }
        return handler.next(e);
      },
      onResponse: (response, handler) {
        debugPrint('--------------------------------');
        debugPrint('Request Path ${response.requestOptions.path}');
        debugPrint("[DIO] Response [code ${response.statusCode}]");
        debugPrint('--------------------------------');
        debugPrint(response.data.toString());
        debugPrint('--------------------------------');
        if (response.statusCode == 401) {
          _logoutUser();
        }
        return handler.next(response);
      },
    ));

  init(BuildContext context1) {
    context = context1;
  }

  static _logoutUser() {
    showErrorToast(
      "Session Expired, Please Login",
    );
    SharedPreferenceService().clearPreference();
    if (context != null) {
      Navigator.of(context!).pushNamedAndRemoveUntil(Routes.authenticationPage, (route) => false);
    }
  }

  ///GET Request without Authentication header
  Future<dynamic> getRequestWithoutAuth(String url, {dynamic data}) async {
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl);
    late Response response;
    try {
      response = await _dio.get(ApiUrl.baseUrl + url, queryParameters: data);
    } catch (e) {
      _handleDioError(e);
    }

    return response.data;
  }

  ///POST Request without Authentication header
  Future<dynamic> postRequestWithoutAuth(String url, {dynamic data}) async {
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl);
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: data);
    } catch (e) {
      _handleDioError(e);
    }
    return response.data;
  }

  ///GET Request with Authentication header
  Future<dynamic> getData(String url, {Map<String, dynamic>? data}) async {
    String token = SharedPreferenceService().accessToken;

    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'});
    late Response response;
    try {
      response = await _dio.get(ApiUrl.baseUrl + url, queryParameters: data);
    } catch (e) {
      _handleDioError(e);
    }
    return response.data;
  }

  ///POST Request with UrlEncoded type
  Future<dynamic> postDataUrlEncoded(String url, {dynamic data}) async {
    String token = SharedPreferenceService().accessToken;
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'}, contentType: 'application/x-www-form-urlencoded');
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: data);
    } catch (e) {
      _handleDioError(e);
    }
    return response.data;
  }

  ///POST Request with JSON Content-Type
  Future<dynamic> postDataJson(String url, {dynamic data}) async {
    String token = SharedPreferenceService().accessToken;
    _dio.options = BaseOptions(baseUrl: ApiUrl.baseUrl, headers: {'Authorization': 'Bearer $token'}, contentType: 'application/json');
    late Response response;
    try {
      response = await _dio.post(
        ApiUrl.baseUrl + url,
        data: jsonEncode(data),
      );
    } catch (e) {
      _handleDioError(e);
    }
    return response.data;
  }

  ///POST Request with Multipart-Form Data Content-Type
  Future<dynamic> postDataFormData(String url, {required dynamic data}) async {
    String token = SharedPreferenceService().accessToken;
    _dio.options = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {'Authorization': 'Bearer $token'},
      contentType: 'multipart/form-data',
    );
    late Response response;
    try {
      response = await _dio.post(ApiUrl.baseUrl + url, data: FormData.fromMap(data));
    } catch (e) {
      _handleDioError(e);
    }
    return response.data;
  }

  ///Download File
  Future<String> downloadFile(String url, String savePath) async {
    try {
      String token = SharedPreferenceService().accessToken;
      _dio.options = BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {
          'Authorization': 'Bearer $token',
          "Connection": "Keep-Alive",
          "Keep-Alive": "timeout=50, max=1000",
        },
      );
      late Response response;
      try {
        response = await _dio
            .download(
              url,
              savePath,
              deleteOnError: true,
            )
            .timeout(const Duration(days: 3));
      } catch (e) {
        _handleDioError(e);
      }
      if (response.statusCode != 200) {
        throw (response.data.toString());
      }
      return savePath;
    } catch (e) {
      rethrow;
    }
  }

  _handleDioError(dynamic errors) {
    if (errors.runtimeType == DioExceptionType) {
      DioException error = errors;
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw ('Connection Timeout');

        case DioExceptionType.sendTimeout:
          throw ('Request Timeout');

        case DioExceptionType.receiveTimeout:
          throw ('Response Timeout');

        case DioExceptionType.badResponse:
          if (error.response!.statusCode == 401) {
            throw ("Session Expired, Please Login");
          } else {
            throw error.response!.data;
          }

        case DioExceptionType.cancel:
          throw ('Connection was canceled');

        case DioExceptionType.unknown:
          if ((error.message ?? "").contains('SocketException')) {
            throw ('No Internet Connection or Server Offline');
          } else {
            throw (error.message.toString());
          }

        default:
          throw (error.message ?? "");
      }
    }
    throw (errors.toString());
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = ((X509Certificate cert, String host, int port) {
        return true;
      });
  }
}
