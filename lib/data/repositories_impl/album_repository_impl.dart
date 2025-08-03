import 'package:drift/drift.dart';
import 'package:media_guard_v2/data/datasources/local_database/app_database.dart';
import 'package:media_guard_v2/data/datasources/local_database/daos/album_dao.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final AlbumDao _albumDao;

  AlbumRepositoryImpl(this._albumDao);

  @override
  Future<List<GuardAlbumModel>> getAllAlbums() async {
    final albums = await _albumDao.getAllAlbums();
    return albums.map((album) => GuardAlbumModel.fromDriftRowModel(album)).toList();
  }

  @override
  Future<bool> updateAlbum(GuardAlbumModel album) async {
    final rowsAffected = await _albumDao.updateAlbum(album.toDriftCompanion());
    return rowsAffected > 0;
  }

  @override
  Future<int> addAlbum({required String name, int? id}) async {
    late GuardAlbumsCompanion newAlbum;
    if (id != null) {
      newAlbum = GuardAlbumsCompanion.insert(
        id: Value(id),
        name: name,
      );
    } else {
      newAlbum = GuardAlbumsCompanion.insert(
        name: name,
      );
    }

    return _albumDao.insertAlbum(newAlbum);
  }

  @override
  Future<bool> deleteAlbum(int id) async {
    final rowsAffected = await _albumDao.deleteAlbum(id);
    return rowsAffected > 0;
  }

  @override
  Future<GuardAlbumModel?> getAlbumById(int id) {
    return _albumDao.getAlbumById(id).then((album) {
      if (album != null) {
        return GuardAlbumModel.fromDriftRowModel(album);
      }
      return null;
    });
  }
}
