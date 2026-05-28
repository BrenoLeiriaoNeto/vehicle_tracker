import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio;

  HttpClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://deividfortuna.github.io/fipe/v1',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
}
