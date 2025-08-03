import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/album_unlock_navigator.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:media_guard_v2/presentation/features/media_viewer/cubit/media_viewer_cubit.dart';
import 'package:video_player/video_player.dart';

class MediaViewerScreen extends StatefulWidget {
  final List<GuardFileModel> images;
  final int initialIndex;
  final int? albumId;
  final bool isGuestMode;
  final Function(GuardFileModel)? onMediaEdited;

  const MediaViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
    this.albumId,
    this.isGuestMode = false,
    this.onMediaEdited,
  });

  @override
  State<MediaViewerScreen> createState() => _MediaViewerScreenState();
}

class _MediaViewerScreenState extends State<MediaViewerScreen> {
  late PageController pageController;
  late MediaViewerCubit _cubit;

  // Each image has its own TransformationController for InteractiveViewer
  late List<TransformationController> controllers;
  late List<VoidCallback> listeners;
  bool _isZoomed = false;
  final Map<int, int> _imageRefreshKeys = {};

  // Video controllers
  final Map<int, VideoPlayerController> _videoControllers = {};

  // Cờ để track trạng thái xác thực trong chế độ khách
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _cubit = MediaViewerCubit(
      mediaFiles: widget.images,
      initialIndex: widget.initialIndex,
      albumId: widget.albumId,
      isGuestMode: widget.isGuestMode,
      onMediaEdited: widget.onMediaEdited,
    );

    pageController = PageController(initialPage: widget.initialIndex);
    controllers = List.generate(
      widget.images.length,
      (_) => TransformationController(),
    );

    // Create listeners for all controllers
    listeners = List.generate(
      widget.images.length,
      (index) =>
          () => _updateZoomState(index),
    );

    // Add listeners to all controllers
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(listeners[i]);
    }

    // Initialize video controllers for video files
    _initializeVideoControllers();
  }

  Future<void> _initializeVideoControllers() async {
    for (int i = 0; i < widget.images.length; i++) {
      final file = widget.images[i];
      if (file.type == GuardFileType.video) {
        try {
          final controller = VideoPlayerController.file(File(file.filePath));
          await controller.initialize();
          _videoControllers[i] = controller;
        } catch (e) {
          // Failed to initialize video controller
        }
      }
    }
  }

  void _updateZoomState(int controllerIndex) {
    if (controllerIndex == _cubit.state.currentIndex) {
      final newZoomState = controllers[controllerIndex].value.getMaxScaleOnAxis() > 1.0;
      if (newZoomState != _isZoomed) {
        setState(() {
          _isZoomed = newZoomState;
        });
      }
    }
  }

  @override
  void dispose() {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].removeListener(listeners[i]);
      controllers[i].dispose();
    }

    // Dispose video controllers
    for (final controller in _videoControllers.values) {
      controller.dispose();
    }

    pageController.dispose();
    _cubit.close();
    super.dispose();
  }

  GuardFileModel get currentImage => widget.images[_cubit.state.currentIndex];

  Future<void> _handleBackNavigation() async {
    // Nếu đã xác thực rồi thì pop luôn
    if (_isAuthenticated || !widget.isGuestMode) {
      Navigator.pop(context);
      return;
    }

    // Nếu chưa xác thực, show màn unlock
    AlbumUnlockNavigator.navigateToAlbumUnlock(
      AlbumUnlockNavigatorParams(
        title: AppStrings.enterPassword,
        albumId: widget.albumId,
        mode: AlbumUnlockMode.unlock,
        onComplete: (bool success) {
          if (success) {
            // Xác thực thành công, set cờ và pop màn hình hiện tại
            setState(() {
              _isAuthenticated = true;
            });
            Navigator.pop(context);
          }
        },
        onCancel: () {
          // Xác thực thất bại hoặc hủy, không làm gì (ở lại màn hình)
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<MediaViewerCubit, MediaViewerState>(
        builder: (context, state) {
          return PopScope(
            canPop: !widget.isGuestMode || _isAuthenticated,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              if (widget.isGuestMode && !_isAuthenticated) {
                await _handleBackNavigation();
              }
            },
            child: Scaffold(
              backgroundColor: Colors.black,
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacityValue(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),
                ),
                actions: [
                  if (widget.albumId != null && !widget.isGuestMode)
                    PopupMenuButton<String>(
                      icon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacityValue(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.more_vert, color: Colors.white),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) async {
                        if (value == 'set_thumbnail') {
                          await _cubit.setThumbnail();
                        } else if (value == 'edit_image') {
                          await _cubit.editImage(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'set_thumbnail',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.image,
                                size: 20,
                                color: Color(0xFF8B92A5),
                              ),
                              const SizedBox(width: 8),
                              Text(AppStrings.setAsThumbnail),
                            ],
                          ),
                        ),
                        if (_cubit.isCurrentMediaImage)
                          PopupMenuItem(
                            value: 'edit_image',
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xFF8B92A5),
                                ),
                                const SizedBox(width: 8),
                                Text(AppStrings.editImage),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              body: Stack(
                children: [
                  PageView.builder(
                    controller: pageController,
                    physics: _isZoomed ? const NeverScrollableScrollPhysics() : const PageScrollPhysics(),
                    itemCount: widget.images.length,
                    onPageChanged: (index) {
                      _cubit.switchToMedia(index);
                    },
                    itemBuilder: (context, index) {
                      final file = widget.images[index];
                      return _buildMediaItem(file, index);
                    },
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacityValue(0.5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaItem(GuardFileModel file, int index) {
    if (file.type == GuardFileType.video) {
      return _buildVideoItem(file, index);
    } else {
      return _buildImageItem(file, index);
    }
  }

  Widget _buildImageItem(GuardFileModel file, int index) {
    return InteractiveViewer(
      transformationController: controllers[index],
      minScale: 1.0,
      maxScale: 5.0,
      scaleEnabled: true,
      panEnabled: true,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Image.file(
            File(file.filePath),
            key: ValueKey('${file.id}_${_imageRefreshKeys[file.id] ?? 0}_${file.createdAt.millisecondsSinceEpoch}'),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image,
              color: Colors.white,
              size: 80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoItem(GuardFileModel file, int index) {
    final videoController = _videoControllers[index];

    if (videoController == null) {
      return const Center(
        child: Icon(
          Icons.video_file,
          color: Colors.white,
          size: 80,
        ),
      );
    }

    return Stack(
      children: [
        Center(
          child: AspectRatio(
            aspectRatio: videoController.value.aspectRatio,
            child: VideoPlayer(videoController),
          ),
        ),
        if (!videoController.value.isPlaying)
          Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  videoController.play();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
