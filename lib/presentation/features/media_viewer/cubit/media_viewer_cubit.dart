import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/events/app_event_stream.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';
import 'package:video_player/video_player.dart';

part 'media_viewer_state.dart';

class MediaViewerCubit extends Cubit<MediaViewerState> {
  final List<GuardFileModel> mediaFiles;
  final int initialIndex;
  final int? albumId;
  final bool isGuestMode;
  final Function(GuardFileModel)? onMediaEdited;

  // Video controllers
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, int> _imageRefreshKeys = {};

  MediaViewerCubit({
    required this.mediaFiles,
    required this.initialIndex,
    this.albumId,
    this.isGuestMode = false,
    this.onMediaEdited,
  }) : super(MediaViewerState.initial(initialIndex)) {
    // Don't initialize video controllers in constructor
    // They will be initialized on demand
  }

  Future<void> initializeVideoController(int index) async {
    if (_videoControllers.containsKey(index)) {
      return; // Already initialized
    }

    final file = mediaFiles[index];
    if (file.type != GuardFileType.video) {
      return; // Not a video file
    }

    try {
      final controller = VideoPlayerController.file(File(file.filePath));
      await controller.initialize();

      // Add listener to update state when video play/pause
      controller.addListener(() {
        if (index == state.currentIndex) {
          emit(state.copyWith(isVideoPlaying: controller.value.isPlaying));
        }
      });

      _videoControllers[index] = controller;

      // Emit state to notify UI that video controller is ready
      if (index == state.currentIndex) {
        emit(state.copyWith(status: MediaViewerStatus.loaded));
      }
    } catch (e) {
      debugPrint('Failed to initialize video controller for index $index: $e');
    }
  }

  void switchToMedia(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      // Pause current video if playing
      final currentVideoController = _videoControllers[state.currentIndex];
      if (currentVideoController != null && currentVideoController.value.isPlaying) {
        currentVideoController.pause();
      }

      emit(state.copyWith(currentIndex: index));
    }
  }

  void toggleVideoPlayback() {
    final videoController = _videoControllers[state.currentIndex];
    if (videoController != null) {
      if (videoController.value.isPlaying) {
        videoController.pause();
      } else {
        videoController.play();
      }
      // State will be updated by the listener in _initializeVideoControllers
    }
  }

  VideoPlayerController? getVideoController(int index) {
    return _videoControllers[index];
  }

  bool isVideoFile(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      return mediaFiles[index].type == GuardFileType.video;
    }
    return false;
  }

  Future<void> setThumbnail(BuildContext context) async {
    if (state.currentIndex >= 0 && state.currentIndex < mediaFiles.length) {
      final currentFile = mediaFiles[state.currentIndex];

      try {
        final albumRepository = getIt<AlbumRepository>();
        final album = await albumRepository.getAlbumById(albumId!);

        if (album == null) {
          throw Exception(AppStrings.albumNotFound);
        }

        final updatedAlbum = album.copyWith(
          fileThumbailPath: currentFile.filePath,
        );

        final success = await albumRepository.updateAlbum(updatedAlbum);

        if (success) {
          // Emit event for album update
          AppEventStream().albumUpdated(updatedAlbum);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.thumbnailSet)),
            );
          }
        } else {
          throw Exception(AppStrings.failedToUpdateAlbum);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.failedToSetThumbnail)),
          );
        }
      }
    }
  }

  Future<void> editImage(BuildContext context) async {
    if (state.currentIndex >= 0 && state.currentIndex < mediaFiles.length) {
      final currentFile = mediaFiles[state.currentIndex];

      // Only allow editing for image files
      if (currentFile.type != GuardFileType.image) {
        return;
      }

      try {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProImageEditor.file(
              currentFile.filePath,
              callbacks: ProImageEditorCallbacks(
                onImageEditingComplete: (Uint8List bytes) async {
                  try {
                    final file = File(currentFile.filePath);
                    await file.writeAsBytes(bytes);

                    // Clear image cache to force reload
                    PaintingBinding.instance.imageCache.clear();
                    PaintingBinding.instance.imageCache.clearLiveImages();

                    if (context.mounted) {
                      // Update refresh key for this image
                      _imageRefreshKeys[currentFile.id] = DateTime.now().millisecondsSinceEpoch;

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(AppStrings.imageEdited)),
                      );

                      // Create updated file model and notify parent screen
                      final updatedFile = GuardFileModel(
                        id: currentFile.id,
                        albumId: currentFile.albumId,
                        filePath: currentFile.filePath,
                        type: currentFile.type,
                        createdAt: DateTime.now(), // Use current time to indicate modification
                      );
                      onMediaEdited?.call(updatedFile);
                    }
                  } catch (e) {
                    if (context.mounted) {
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
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppStrings.errorOpeningImageEditor),
            ),
          );
        }
      }
    }
  }

  int? getImageRefreshKey(int fileId) {
    return _imageRefreshKeys[fileId];
  }

  @override
  Future<void> close() {
    // Dispose video controllers
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }
    return super.close();
  }
}
