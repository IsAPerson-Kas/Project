import 'package:drift/drift.dart';

class GuardAlbums extends Table {
  // Có cột id dùng autoIncrement() thì Drift sẽ dùng cột này làm khóa chính
  // Nếu không có cột id thì Drift sẽ dùng rowid mặc định (ẩn)
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get password => text().nullable()();
  TextColumn get fileThumbailPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
