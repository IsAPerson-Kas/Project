import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class NativeShare {
  static const _channel = MethodChannel('vn.tinasoft.native_share');

  /// Share một hoặc nhiều file (ảnh, pdf, v.v.)
  static Future<void> shareFiles(List<File> files, {String? text}) async {
    final copiedPaths = <String>[];

    for (final file in files) {
      if (!await file.exists()) continue;

      final copied = await _copyToCache(file);
      copiedPaths.add(copied.path);
    }

    if (copiedPaths.isEmpty) return;

    await _channel.invokeMethod('shareFiles', {
      'paths': copiedPaths,
      'text': text ?? '',
    });
  }

  /// Copy file sang thư mục cache để FileProvider xử lý an toàn
  static Future<File> _copyToCache(File file) async {
    final cacheDir = await getTemporaryDirectory();
    final newPath = '${cacheDir.path}/${file.uri.pathSegments.last}';
    return file.copy(newPath);
  }
}
