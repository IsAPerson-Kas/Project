import 'package:drift/drift.dart';
import 'package:media_guard_v2/data/datasources/local_database/app_database.dart';

class GuardAlbumModel {
  final int id;
  final String name;
  final String? password;
  final String? fileThumbailPath;
  final DateTime createdAt;

  const GuardAlbumModel({
    required this.id,
    required this.name,
    this.password,
    this.fileThumbailPath,
    required this.createdAt,
  });

  GuardAlbumModel copyWith({
    int? id,
    String? name,
    String? password,
    String? fileThumbailPath,
    DateTime? createdAt,
  }) {
    return GuardAlbumModel(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password, // Không dùng ?? nữa, phải truyền đầy đủ
      fileThumbailPath: fileThumbailPath, // Không dùng ?? nữa, phải truyền đầy đủ
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory GuardAlbumModel.fromDriftRowModel(
    GuardAlbum driftModel,
  ) {
    return GuardAlbumModel(
      id: driftModel.id,
      name: driftModel.name,
      password: driftModel.password,
      fileThumbailPath: driftModel.fileThumbailPath,
      createdAt: driftModel.createdAt,
    );
  }

  GuardAlbumsCompanion toDriftCompanion() {
    final companion = GuardAlbumsCompanion(
      id: Value(id),
      name: Value(name),
      password: Value(password), // Use Value(null) to explicitly set to NULL
      fileThumbailPath: Value(fileThumbailPath), // Use Value(null) to explicitly set to NULL
      createdAt: Value(createdAt),
    );
    return companion;
  }
}
