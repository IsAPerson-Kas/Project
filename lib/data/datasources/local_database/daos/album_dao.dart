import 'package:drift/drift.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_album.dart';

import '../app_database.dart';

part 'album_dao.g.dart';

@DriftAccessor(tables: [GuardAlbums])
class AlbumDao extends DatabaseAccessor<AppDatabase> with _$AlbumDaoMixin {
  AlbumDao(super.db);

  /// Insert một album mới vào cơ sở dữ liệu.
  ///
  /// ✅ Thành công: Trả về `int` là `id` của bản ghi mới được insert.
  /// ❌ Thất bại: Ném exception nếu vi phạm ràng buộc (ví dụ: thiếu trường bắt buộc).
  Future<int> insertAlbum(GuardAlbumsCompanion entry) => into(guardAlbums).insert(entry);

  /// Lấy thông tin album theo `id`.
  ///
  /// ✅ Thành công: Trả về `GuardAlbum` nếu tồn tại.
  /// ❌ Không tìm thấy: Trả về `null`.
  Future<GuardAlbum?> getAlbumById(int id) {
    return (select(guardAlbums)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  /// Lấy toàn bộ danh sách album trong cơ sở dữ liệu.
  ///
  /// ✅ Thành công: Trả về `List<GuardAlbum>` (có thể rỗng nếu không có dữ liệu).
  /// ❌ Thất bại: Ném exception nếu có lỗi truy vấn.
  Future<List<GuardAlbum>> getAllAlbums() => select(guardAlbums).get();

  /// Lấy danh sách album có phân trang.
  ///
  /// ✅ Thành công: Trả về `List<GuardAlbum>` theo `offset` và `limit`.
  /// ❌ Thất bại: Ném exception nếu truy vấn lỗi.
  Future<List<GuardAlbum>> getAlbumsPaged(int offset, int limit) {
    return (select(guardAlbums)..limit(limit, offset: offset)).get();
  }

  /// Cập nhật thông tin album dựa trên `id` trong `entry`.
  ///
  /// ✅ Thành công: Trả về `int` là số bản ghi được cập nhật.
  /// ❌ Không tìm thấy `id` hoặc không có gì thay đổi: Trả về `0`.
  /// ❌ `entry.id` không có giá trị: Ném `ArgumentError`.
  Future<int> updateAlbum(GuardAlbumsCompanion entry) async {
    if (entry.id.present) {
      return await (update(guardAlbums)..where((tbl) => tbl.id.equals(entry.id.value))).write(entry);
    }
    throw ArgumentError('${AppStrings.idMustBePresent} album');
  }

  /// Xóa album theo `id`.
  ///
  /// ✅ Thành công: Trả về `int` là số bản ghi bị xóa.
  /// ❌ Không tìm thấy bản ghi: Trả về `0`.
  Future<int> deleteAlbum(int id) async {
    return await (delete(guardAlbums)..where((tbl) => tbl.id.equals(id))).go();
  }
}
