import 'package:equatable/equatable.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';

// Base class for all app events
abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

// Album-related events
class AlbumCreatedEvent extends AppEvent {
  final GuardAlbumModel album;
  final DateTime timestamp;

  const AlbumCreatedEvent({
    required this.album,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [album, timestamp];
}

class AlbumUpdatedEvent extends AppEvent {
  final GuardAlbumModel album;
  final DateTime timestamp;

  const AlbumUpdatedEvent({
    required this.album,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [album, timestamp];
}

class AlbumDeletedEvent extends AppEvent {
  final int albumId;
  final DateTime timestamp;

  const AlbumDeletedEvent({
    required this.albumId,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [albumId, timestamp];
}
