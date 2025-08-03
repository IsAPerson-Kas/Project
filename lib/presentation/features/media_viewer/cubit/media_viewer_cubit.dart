import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/events/app_event_stream.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

part 'media_viewer_state.dart';

class MediaViewerCubit extends Cubit<MediaViewerState> {
  final List<GuardFileModel> mediaFiles;
  final int initialIndex;
  final int? albumId;
  final bool isGuestMode;
  final Function(GuardFileModel)? onMediaEdited;

  MediaViewerCubit({
    required this.mediaFiles,
    required this.initialIndex,
    this.albumId,
    this.isGuestMode = false,
    this.onMediaEdited,
  }) : super(MediaViewerState.initial(initialIndex));

  GuardFileModel get currentMedia => mediaFiles[state.currentIndex];

  /// Switch to a different media file
  void switchToMedia(int index) {
    if (index >= 0 && index < mediaFiles.length && index != state.currentIndex) {
      emit(state.copyWith(currentIndex: index));
    }
  }

  /// Set thumbnail for current album
  Future<void> setThumbnail() async {
    if (albumId == null) return;

    try {
      emit(state.copyWith(status: MediaViewerStatus.loading));

      final albumRepository = getIt<AlbumRepository>();
      final album = await albumRepository.getAlbumById(albumId!);

      if (album == null) {
        throw Exception(AppStrings.albumNotFound);
      }

      final updatedAlbum = album.copyWith(
        fileThumbailPath: currentMedia.filePath,
      );

      final success = await albumRepository.updateAlbum(updatedAlbum);

      if (success) {
        // Emit event for album update
        AppEventStream().albumUpdated(updatedAlbum);
        emit(state.copyWith(status: MediaViewerStatus.success));
      } else {
        throw Exception(AppStrings.failedToUpdateAlbum);
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: MediaViewerStatus.error,
          errorMessage: AppStrings.failedToSetThumbnail,
        ),
      );
    }
  }

  /// Edit image (only for image files)
  Future<void> editImage(BuildContext context) async {
    if (currentMedia.type != GuardFileType.image) return;

    try {
      emit(state.copyWith(status: MediaViewerStatus.loading));

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProImageEditor.file(
            currentMedia.filePath,
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (Uint8List bytes) async {
                try {
                  final file = File(currentMedia.filePath);
                  await file.writeAsBytes(bytes);

                  // Clear image cache to force reload
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();

                  // Create updated file model and notify parent screen
                  final updatedFile = GuardFileModel(
                    id: currentMedia.id,
                    albumId: currentMedia.albumId,
                    filePath: currentMedia.filePath,
                    type: currentMedia.type,
                    createdAt: DateTime.now(), // Use current time to indicate modification
                  );
                  onMediaEdited?.call(updatedFile);

                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.imageEdited)),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppStrings.errorSavingEditedImage),
                      ),
                    );
                  }
                }
              },
            ),
          ),
        ),
      );

      emit(state.copyWith(status: MediaViewerStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: MediaViewerStatus.error,
          errorMessage: AppStrings.errorOpeningImageEditor,
        ),
      );
    }
  }

  /// Check if current media is video
  bool get isCurrentMediaVideo => currentMedia.type == GuardFileType.video;

  /// Check if current media is image
  bool get isCurrentMediaImage => currentMedia.type == GuardFileType.image;

  /// Get available actions for current media
  List<MediaViewerAction> get availableActions {
    final actions = <MediaViewerAction>[];

    if (albumId != null && !isGuestMode) {
      actions.add(MediaViewerAction.setThumbnail);

      if (isCurrentMediaImage) {
        actions.add(MediaViewerAction.edit);
      }
    }

    return actions;
  }
}

enum MediaViewerAction {
  setThumbnail,
  edit,
}

enum MediaViewerStatus {
  initial,
  loading,
  success,
  error,
}
