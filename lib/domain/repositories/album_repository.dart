import 'package:media_guard_v2/domain/models/guard_album_model.dart';

abstract class AlbumRepository {
  /// Lấy danh sách album
  Future<List<GuardAlbumModel>> getAllAlbums();

  /// sửa album
  Future<bool> updateAlbum(GuardAlbumModel album);

  /// Thêm album mới
  Future<int> addAlbum({required String name, int? id});

  /// Lấy album theo ID
  Future<GuardAlbumModel?> getAlbumById(int id);

  /// Xóa album theo ID
  Future<bool> deleteAlbum(int id);
}
