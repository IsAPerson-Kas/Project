import 'dart:async';

import 'package:media_guard_v2/core/events/app_events.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';

class AppEventStream {
  // Singleton pattern
  static final AppEventStream _instance = AppEventStream._internal();
  factory AppEventStream() => _instance;
  AppEventStream._internal();

  // StreamController for broadcasting events
  final _eventController = StreamController<AppEvent>.broadcast();

  // Getter for the stream
  Stream<AppEvent> get events => _eventController.stream;

  // Method to emit any AppEvent
  void addEvent(AppEvent event) {
    _eventController.sink.add(event);
  }

  // Convenience methods for album events
  void albumCreated(GuardAlbumModel album) {
    addEvent(
      AlbumCreatedEvent(
        album: album,
        timestamp: DateTime.now(),
      ),
    );
  }

  void albumUpdated(GuardAlbumModel album) {
    addEvent(
      AlbumUpdatedEvent(
        album: album,
        timestamp: DateTime.now(),
      ),
    );
  }

  void albumDeleted(int albumId) {
    addEvent(
      AlbumDeletedEvent(
        albumId: albumId,
        timestamp: DateTime.now(),
      ),
    );
  }

  void dispose() {
    _eventController.close();
  }
}
