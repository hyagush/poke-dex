// http_service_impl.dart

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:poke_dex/src/core/services/network/http_service.dart';

class HttpServiceImpl implements HttpService {
  late final Dio _dio;

  HttpServiceImpl() {
    _dio = DioForNative(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  @override
  HttpService auth() {
    _dio.interceptors.add(AuthInterceptor());
    return this;
  }

  @override
  HttpService unauth() {
    _dio.interceptors.removeWhere(
      (interceptor) => interceptor is AuthInterceptor,
    );
    return this;
  }

  @override
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return _dio.get(path, queryParameters: queryParameters);
  }
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    const token = 'SEU_TOKEN_AQUI';
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}
