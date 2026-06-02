import 'package:dio/dio.dart';

class HttpClient {
  final Dio dio;

  HttpClient()
    : dio = Dio(
        BaseOptions(
          baseUrl: 'https://fipe.parallelum.com.br/api/v2',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
}
