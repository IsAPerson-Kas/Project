import 'package:drift/drift.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_album.dart';

class GuardFiles extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get albumId => integer().references(GuardAlbums, #id)();
  TextColumn get filePath => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get type => integer()(); // 0: image, 1: video
}

enum GuardFileType {
  image,
  video;

  static GuardFileType fromRawValue(int value) {
    switch (value) {
      case 0:
        return GuardFileType.image;
      case 1:
        return GuardFileType.video;
      default:
        throw ArgumentError('Invalid file type value: $value');
    }
  }

  static int toRawValue(GuardFileType type) {
    switch (type) {
      case GuardFileType.image:
        return 0;
      case GuardFileType.video:
        return 1;
    }
  }
}
