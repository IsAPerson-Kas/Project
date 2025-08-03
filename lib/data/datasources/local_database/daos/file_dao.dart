import 'dart:developer';

import 'package:drift/drift.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';

import '../app_database.dart';

part 'file_dao.g.dart';

@DriftAccessor(tables: [GuardFiles])
class FileDao extends DatabaseAccessor<AppDatabase> with _$FileDaoMixin {
  FileDao(super.db);

  /// Thêm một bản ghi `GuardFile` mới vào cơ sở dữ liệu.
  ///
  /// ✅ Thành công: Trả về `int` là ID (`id`) của bản ghi mới được insert.
  /// ❌ Thất bại: Gặp lỗi (ví dụ: vi phạm khóa ngoại), ghi log và trả về `null`.
  Future<int?> insertFile(GuardFilesCompanion file) async {
    try {
      return await into(guardFiles).insert(file);
    } catch (e) {
      log('Insert file failed: $e');
      return null;
    }
  }

  /// Lấy danh sách tất cả file thuộc một album cụ thể.
  ///
  /// ✅ Thành công: Trả về `List<GuardFile>` (có thể rỗng nếu album không có file).
  /// ❌ Thất bại: Ném exception nếu xảy ra lỗi trong truy vấn.
  Future<List<GuardFile>> getFilesByAlbum(int albumId) {
    return (select(guardFiles)..where((f) => f.albumId.equals(albumId))).get();
  }

  /// Lấy danh sách file theo `albumId` có phân trang.
  ///
  /// ✅ Thành công: Trả về `List<GuardFile>` giới hạn theo `offset` và `limit`.
  /// ❌ Thất bại: Ném exception nếu có lỗi trong truy vấn.
  Future<List<GuardFile>> getFilesPaged(int albumId, int offset, int limit) {
    return (select(guardFiles)
          ..where((f) => f.albumId.equals(albumId))
          ..limit(limit, offset: offset))
        .get();
  }

  /// Cập nhật thông tin file theo `id`.
  ///
  /// ✅ Thành công: Trả về `true` nếu có bản ghi được cập nhật.
  /// ❌ Không tìm thấy `id` hoặc không có thay đổi: Trả về `false`.
  /// ❌ `entry.id` không được cung cấp: Ném `ArgumentError`.
  Future<bool> updateFile(GuardFilesCompanion entry) async {
    if (entry.id.present) {
      final result = await (update(guardFiles)..where((f) => f.id.equals(entry.id.value))).write(entry);
      return result > 0;
    }
    throw ArgumentError('${AppStrings.idMustBePresent} file');
  }

  /// Xoá một file theo `id`.
  ///
  /// ✅ Thành công: Trả về `true` nếu có bản ghi bị xoá.
  /// ❌ Không tìm thấy bản ghi cần xoá: Trả về `false`.
  Future<bool> deleteFile(int id) async {
    final rowsAffected = await (delete(guardFiles)..where((f) => f.id.equals(id))).go();
    return rowsAffected > 0;
  }

  /// Xoá tất cả các file thuộc một album cụ thể.
  ///
  /// ✅ Thành công: Trả về `int` là số lượng bản ghi đã bị xoá.
  /// ❌ Thất bại: Ném exception nếu truy vấn lỗi.
  Future<int> deleteFilesByAlbum(int albumId) {
    return (delete(guardFiles)..where((f) => f.albumId.equals(albumId))).go();
  }
}
