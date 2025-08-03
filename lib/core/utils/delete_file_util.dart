import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/utils/device_info.dart';
import 'package:photo_manager/photo_manager.dart';

Future<bool> deleteLocalFiles(List<String> localIDs) async {
  dev.log("Trying to delete local files ");
  final List<String> deletedIDs = [];

  try {
    // Kiểm tra Android SDK version để quyết định cách xóa
    final bool shouldDeleteInBatches = await isAndroidSDKVersionLowerThan(AppStrings.android11SDKINT);

    if (shouldDeleteInBatches) {
      dev.log("Deleting in batches");
      // Xóa theo batch để tránh crash trên Android cũ
      deletedIDs.addAll(await deleteLocalFilesInBatches(localIDs));
    } else {
      dev.log("Deleting in one shot");
      // Xóa tất cả cùng lúc trên Android mới
      deletedIDs.addAll(await _deleteLocalFilesInOneShot(localIDs));
    }

    // Fallback cho iOS khi thư viện không xóa được
    if (deletedIDs.isEmpty && Platform.isIOS) {
      deletedIDs.addAll(
        await _iosDeleteLocalFilesInBatchesFallback(localIDs),
      );
    }

    if (deletedIDs.isNotEmpty) {
      dev.log("${deletedIDs.length} files deleted locally");
      return true;
    } else {
      // Workaround cho Android 10 - thư viện không trả về đúng deletedIDs
      if (!await isAndroidSDKVersionLowerThan(AppStrings.android11SDKINT)) {
        return false;
      }
      return true;
    }
  } catch (e, s) {
    dev.log("Could not delete local files $e - $s");
    return false;
  }
}

/// Xóa file trong một lần - dành cho Android mới
Future<List<String>> _deleteLocalFilesInOneShot(List<String> localIDs) async {
  dev.log('starting _deleteLocalFilesInOneShot for ${localIDs.length}');
  final List<String> deletedIDs = [];

  // Hiển thị progress dialog deleting x files back uped files...

  try {
    // ĐÂY LÀ PHẦN CHÍNH: Sử dụng PhotoManager để xóa file từ thư viện ảnh
    deletedIDs.addAll(await PhotoManager.editor.deleteWithIds(localIDs));
  } catch (e, s) {
    dev.log("Could not delete files $e - $s");
  }

  dev.log(
    '_deleteLocalFilesInOneShot deleted ${deletedIDs.length} out '
    'of ${localIDs.length}',
  );
  // ẩn progress dialog
  return deletedIDs;
}

/// Xóa file theo batch - dành cho Android cũ và iOS
Future<List<String>> deleteLocalFilesInBatches(
  List<String> localIDs, {
  int minimumParts = 10,
  int minimumBatchSize = 1,
  int maximumBatchSize = 100,
}) async {
  // Hiển thị progress dialog Delete x files back uped files...

  // Hiển thị progress dialog

  // Tính batch size phù hợp
  final batchSize = min(
    max(minimumBatchSize, (localIDs.length / minimumParts).round()),
    maximumBatchSize,
  );
  dev.log("Batch size: $batchSize");

  final List<String> deletedIDs = [];

  // Xóa từng batch
  for (int index = 0; index < localIDs.length; index += batchSize) {
    // set progress dialog title

    final ids = localIDs.getRange(index, min(localIDs.length, index + batchSize)).toList();
    dev.log("Trying to delete $ids");

    try {
      // ĐÂY LÀ PHẦN CHÍNH: Xóa batch sử dụng PhotoManager
      deletedIDs.addAll(await PhotoManager.editor.deleteWithIds(ids));
      dev.log("Deleted $ids");
    } catch (e, s) {
      dev.log("Could not delete batch  ${ids.toString()} $e - $s");

      // Nếu batch fail, thử xóa từng file một
      for (final id in ids) {
        try {
          deletedIDs.addAll(await PhotoManager.editor.deleteWithIds([id]));
          dev.log("Deleted $id");
        } catch (e, s) {
          dev.log("Could not delete file $id $e - $s");
        }
      }
    }
  }

  // ẩn progress dialog
  return deletedIDs;
}

/// Fallback xóa file cho iOS khi thư viện fail
Future<List<String>> _iosDeleteLocalFilesInBatchesFallback(
  List<String> localAssetIDs,
) async {
  final List<String> deletedIDs = [];

  dev.log("Trying to delete local files in batches");
  deletedIDs.addAll(
    await _deleteLocalFilesInBatchesRecursively(localAssetIDs),
  );

  if (deletedIDs.isEmpty) {
    dev.log("Failed to delete local files in recursively batches");
  }

  dev.log(
    "iOS free-space fallback, deleted ${deletedIDs.length} files with distinct localIDs"
    "in batches}",
  );

  return deletedIDs;
}

/// Xóa file theo cách đệ quy - chia nhỏ batch khi fail
Future<List<String>> _deleteLocalFilesInBatchesRecursively(List<String> localAssetIDs) async {
  if (localAssetIDs.isEmpty) return [];

  final deletedIDs = await _deleteLocalFiles(localAssetIDs);
  if (deletedIDs.isNotEmpty) {
    return deletedIDs;
  }

  if (localAssetIDs.length == 1) {
    dev.log("Failed to delete file ${localAssetIDs.first}");
    return [];
  }

  // Chia đôi list và thử xóa đệ quy
  final midIndex = localAssetIDs.length ~/ 2;
  final left = localAssetIDs.sublist(0, midIndex);
  final right = localAssetIDs.sublist(midIndex);

  final leftDeleted = await _deleteLocalFilesInBatchesRecursively(left);
  final rightDeleted = await _deleteLocalFilesInBatchesRecursively(right);

  return [...leftDeleted, ...rightDeleted];
}

/// Helper function để xóa một batch file
Future<List<String>> _deleteLocalFiles(List<String> localIDs) async {
  dev.log("Trying to delete batch of size ${localIDs.length}  :  $localIDs");

  // Hiển thị progress dialog deleting x files back uped files...

  final List<String> deletedIDs = [];
  try {
    deletedIDs.addAll(await PhotoManager.editor.deleteWithIds(localIDs));
    dev.log("Deleted $localIDs");
  } catch (e, s) {
    dev.log("Could not delete batch $localIDs $e - $s");
    // show error dialog
  }
  // ẩn progress dialog
  return deletedIDs;
}
