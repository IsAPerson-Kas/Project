# Event Stream System

Hệ thống event stream được thiết kế để tối ưu hóa hiệu suất bằng cách chỉ cập nhật những album thực sự thay đổi thay vì load lại toàn bộ danh sách album.

## Cách hoạt động

### 1. AppEventStream (Singleton)
- Quản lý stream controller để broadcast các events
- Cung cấp các convenience methods để emit events dễ dàng

### 2. AppEvent (Base class)
- Lớp cơ sở cho tất cả các events
- Sử dụng Equatable để so sánh events

### 3. Album Events
- `AlbumCreatedEvent`: Khi tạo album mới (truyền album model)
- `AlbumUpdatedEvent`: Khi cập nhật thông tin album (truyền album model đã update)
- `AlbumDeletedEvent`: Khi xóa album (truyền album ID)

## Cách sử dụng

### Emit Events
```dart
// Tạo album mới
AppEventStream().albumCreated(albumModel);

// Cập nhật album
AppEventStream().albumUpdated(updatedAlbumModel);

// Xóa album
AppEventStream().albumDeleted(albumId);
```

### Listen Events
```dart
class MyCubit extends Cubit<MyState> {
  late StreamSubscription _eventSubscription;

  MyCubit() : super(MyInitial()) {
    _initializeEventStream();
  }

  void _initializeEventStream() {
    _eventSubscription = AppEventStream().events.listen((event) {
      if (event is AlbumCreatedEvent) {
        _handleAlbumCreated(event);
      } else if (event is AlbumUpdatedEvent) {
        _handleAlbumUpdated(event);
      } else if (event is AlbumDeletedEvent) {
        _handleAlbumDeleted(event);
      }
    });
  }

  void _handleAlbumCreated(AlbumCreatedEvent event) {
    // event.album chứa album model mới được tạo
    final newAlbum = event.album;
    // Xử lý logic thêm album vào UI
  }

  void _handleAlbumUpdated(AlbumUpdatedEvent event) {
    // event.album chứa album model đã được update
    final updatedAlbum = event.album;
    // Xử lý logic cập nhật album trong UI
  }

  void _handleAlbumDeleted(AlbumDeletedEvent event) {
    // event.albumId chứa ID của album bị xóa
    final deletedAlbumId = event.albumId;
    // Xử lý logic xóa album khỏi UI
  }

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }
}
```

## Lợi ích

1. **Hiệu suất cao**: Chỉ cập nhật album thay đổi thay vì load lại toàn bộ
2. **Real-time updates**: UI được cập nhật ngay lập tức khi có thay đổi
3. **Giảm database queries**: Không cần query toàn bộ albums mỗi lần
4. **Data consistency**: Truyền trực tiếp album model đảm bảo dữ liệu chính xác
5. **Scalable**: Dễ dàng thêm events mới khi cần

## Event Structure

### AlbumCreatedEvent
```dart
class AlbumCreatedEvent extends AppEvent {
  final GuardAlbumModel album;  // Album model mới được tạo
  final DateTime timestamp;
}
```

### AlbumUpdatedEvent
```dart
class AlbumUpdatedEvent extends AppEvent {
  final GuardAlbumModel album;  // Album model đã được update
  final DateTime timestamp;
}
```

### AlbumDeletedEvent
```dart
class AlbumDeletedEvent extends AppEvent {
  final int albumId;  // ID của album bị xóa
  final DateTime timestamp;
}
```

## Fallback Strategy

Nếu không thể lấy được album cụ thể từ database, hệ thống sẽ fallback về việc load lại toàn bộ albums để đảm bảo tính nhất quán của dữ liệu. 