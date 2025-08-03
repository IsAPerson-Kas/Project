import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';

abstract class FileRepository {
  /// thêm file vào album
  Future<bool> addFile({required int albumId, required String filePath, required GuardFileType type});

  /// lấy danh sách file theo album
  Future<List<GuardFileModel>> getFilesByAlbum(int albumId);

  /// lấy danh sách file theo album với phân trang
  Future<List<GuardFileModel>> getFilesPaged(int albumId, int offset, int limit);

  /// xóa file theo ID
  Future<bool> deleteFile(int id);
}