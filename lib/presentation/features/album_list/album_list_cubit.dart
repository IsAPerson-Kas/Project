import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/events/app_event_stream.dart';
import 'package:media_guard_v2/core/events/app_events.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/error_dialog.dart';

part 'album_list_state.dart';

class AlbumListCubit extends Cubit<AlbumListState> {
  final AlbumRepository _albumRepository;
  late StreamSubscription _eventSubscription;

  AlbumListCubit({
    required AlbumRepository albumRepository,
    required FileRepository fileRepository,
  }) : _albumRepository = albumRepository,
       super(AlbumListInitial()) {
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

  @override
  Future<void> close() {
    _eventSubscription.cancel();
    return super.close();
  }

  Future<void> loadAlbums() async {
    try {
      emit(AlbumListLoading());
      final albums = await _albumRepository.getAllAlbums();
      // Filter out album with ID 0
      final filteredAlbums = albums.where((album) => album.id != 0).toList();
      emit(AlbumListLoaded(filteredAlbums));
    } catch (e) {
      emit(AlbumListLoaded([]));
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to load albums: ${e.toString()}",
          onClose: () {},
        ),
      );
    }
  }

  Future<void> addAlbum(String name) async {
    try {
      final albumId = await _albumRepository.addAlbum(name: name);
      if (albumId > 0) {
        // Get the specific album using the returned ID
        final newAlbum = await _albumRepository.getAlbumById(albumId);
        if (newAlbum != null) {
          AppEventStream().albumCreated(newAlbum);
        }
      }
      // No need to load all albums since event will handle the update
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to add album: ${e.toString()}",
          onClose: () {},
        ),
      );
    }
  }

  // Event handlers
  void _handleAlbumCreated(AlbumCreatedEvent event) {
    final currentState = state;
    if (currentState is AlbumListLoaded) {
      final updatedAlbums = List<GuardAlbumModel>.from(currentState.albums)..add(event.album);
      emit(AlbumListLoaded(updatedAlbums));
    } else if (currentState is AlbumListLoading) {
      // If we're loading, reload all albums to ensure consistency
      loadAlbums();
    }
  }

  void _handleAlbumUpdated(AlbumUpdatedEvent event) {
    final currentState = state;
    if (currentState is AlbumListLoaded) {
      final updatedAlbums = currentState.albums.map((album) {
        if (album.id == event.album.id) {
          return event.album;
        }
        return album;
      }).toList();
      emit(AlbumListLoaded(updatedAlbums));
    } else if (currentState is AlbumListLoading) {
      // If we're loading, reload all albums to ensure consistency
      loadAlbums();
    }
  }

  void _handleAlbumDeleted(AlbumDeletedEvent event) {
    final currentState = state;
    if (currentState is AlbumListLoaded) {
      final updatedAlbums = currentState.albums.where((album) => album.id != event.albumId).toList();
      emit(AlbumListLoaded(updatedAlbums));
    } else if (currentState is AlbumListLoading) {
      // If we're loading, reload all albums to ensure consistency
      loadAlbums();
    }
  }
}
