import 'package:media_guard_v2/data/datasources/local_database/app_database.dart';
import 'package:media_guard_v2/data/datasources/local_database/daos/file_dao.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileDao _fileDao;

  FileRepositoryImpl(this._fileDao);

  @override
  Future<bool> addFile({required int albumId, required String filePath, required GuardFileType type}) async {
    final newFile = GuardFilesCompanion.insert(
      albumId: albumId,
      filePath: filePath,
      type: GuardFileType.toRawValue(type),
    );

    return _fileDao.insertFile(newFile).then((id) {
      return id != null;
    });
  }

  @override
  Future<bool> deleteFile(int id) {
    return _fileDao.deleteFile(id);
  }

  @override
  Future<List<GuardFileModel>> getFilesByAlbum(int albumId) async {
    final files = await _fileDao.getFilesByAlbum(albumId);
    return files.map((file) => GuardFileModel.fromDriftRowModel(file)).toList();
  }

  @override
  Future<List<GuardFileModel>> getFilesPaged(int albumId, int offset, int limit) async {
    final files = await _fileDao.getFilesPaged(albumId, offset, limit);
    return files.map((file) => GuardFileModel.fromDriftRowModel(file)).toList();
  }
}
