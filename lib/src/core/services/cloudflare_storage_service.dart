import 'dart:io';
import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:vehicle_tracker/src/core/core_exports.dart';

class CloudflareStorageService {
  final HttpClient _client;

  final String _workerUrl =
      'https://vehicle-tracker-signer.bleiriaoneto.workers.dev';

  static const String _publicBucketUrl =
      'https://pub-a033b821689f47959a6e7c528e3a407c.r2.dev';
  static const String _logName = 'STORAGE_SERVICE';

  CloudflareStorageService(this._client);

  Future<String?> uploadAvatar(File file) async {
    try {
      final fileName = file.path.split('/').last;
      final contentType = _lookupMimeType(fileName);

      if (contentType == null) {
        dev.log(
          '⚠️ Formato de arquivo não suportado localmente',
          name: _logName,
        );
        return null;
      }

      dev.log(
        '🔑 1. Solicitando URL pré-assinada para a Worker...',
        name: _logName,
      );
      final presignedUrl = await _getPresignedUrl(fileName, contentType);

      if (presignedUrl == null) return null;

      dev.log(
        '📡 2. Iniciando upload binário via PUT direto para o R2...',
        name: _logName,
      );
      final success = await _uploadToR2(presignedUrl, file, contentType);

      if (success) {
        final finalUrl = '$_publicBucketUrl/$fileName';
        dev.log('✅ Upload concluído com sucesso!', name: _logName);
        return finalUrl;
      }
    } catch (e, stackTrace) {
      dev.log(
        '💥 Erro fatal na rota de upload',
        name: _logName,
        error: e,
        stackTrace: stackTrace,
      );
    }
    return null;
  }

  Future<String?> _getPresignedUrl(String fileName, String contentType) async {
    final response = await _client.dio.post(
      _workerUrl,
      data: {'fileName': fileName, 'contentType': contentType},
    );

    if (response.statusCode == 200) {
      return response.data['url'] as String;
    }
    return null;
  }

  Future<bool> _uploadToR2(String url, File file, String contentType) async {
    final bytes = await file.readAsBytes();

    final response = await _client.dio.put(
      url,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {'Content-Type': contentType, 'Content-Length': bytes.length},
      ),
    );

    return response.statusCode == 200;
  }

  String? _lookupMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'svg':
        return 'image/svg+xml';
      default:
        return null;
    }
  }
}
