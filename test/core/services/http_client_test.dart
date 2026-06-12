import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vehicle_tracker/src/core/services/http_client.dart';

void main() {
  test('HttpClient configures Dio with baseUrl and timeouts', () {
    final client = HttpClient();

    expect(client.dio.options.baseUrl, 'https://fipe.parallelum.com.br/api/v2');
    expect(client.dio.options.connectTimeout, const Duration(seconds: 10));
    expect(client.dio.options.receiveTimeout, const Duration(seconds: 10));
    expect(client.dio.options, isA<BaseOptions>());
  });
}
