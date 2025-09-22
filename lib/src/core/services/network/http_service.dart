import 'package:dio/dio.dart';

abstract class HttpService {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});

  HttpService auth();
  HttpService unauth();
}
