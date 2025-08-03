import 'package:drift/drift.dart';
import 'package:media_guard_v2/data/datasources/local_database/app_database.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';

class GuardFileModel {
  final int id;
  final int albumId;
  final String filePath;
  final DateTime createdAt;
  final GuardFileType type;

  const GuardFileModel({
    required this.id,
    required this.albumId,
    required this.filePath,
    required this.createdAt,
    required this.type,
  });

  factory GuardFileModel.fromDriftRowModel(GuardFile driftModel) {
    return GuardFileModel(
      id: driftModel.id,
      albumId: driftModel.albumId,
      filePath: driftModel.filePath,
      createdAt: driftModel.createdAt,
      type: GuardFileType.fromRawValue(driftModel.type),
    );
  }

  GuardFilesCompanion toDriftCompanion() {
    return GuardFilesCompanion.insert(
      albumId: albumId,
      filePath: filePath,
      createdAt: Value(createdAt),
      type: GuardFileType.toRawValue(type),
    );
  }
}