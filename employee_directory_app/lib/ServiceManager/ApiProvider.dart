import 'package:dio/dio.dart';

class ApiProvider {
  Dio _dio;

  ApiProvider() {
    BaseOptions options;
    options = new BaseOptions(
      receiveTimeout: 40000, //30s
      connectTimeout: 40000,
    );

    _dio = Dio(options);
  }

  Dio getInstance() {
    _dio.options.headers.addAll({"Content-Type": "application/json"});
    return _dio;
  }
}
