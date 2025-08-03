import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/events/app_event_stream.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/album_unlock_navigator.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:pro_image_editor/core/models/editor_callbacks/pro_image_editor_callbacks.dart';
import 'package:pro_image_editor/features/main_editor/main_editor.dart';

class GuardImageViewerScreen extends StatefulWidget {
  final List<GuardFileModel> images;
  final int initialIndex;
  final int? albumId;
  final bool isGuestMode;
  final Function(GuardFileModel)? onImageEdited;

  const GuardImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
    this.albumId,
    this.isGuestMode = false,
    this.onImageEdited,
  });

  @override
  State<GuardImageViewerScreen> createState() => _GuardImageViewerScreenState();
}

class _GuardImageViewerScreenState extends State<GuardImageViewerScreen> {
  late PageController pageController;
  late int currentIndex;

  // Each image has its own TransformationController for InteractiveViewer
  late List<TransformationController> controllers;
  late List<VoidCallback> listeners;
  bool _isZoomed = false;
  final Map<int, int> _imageRefreshKeys = {};

  // Cờ để track trạng thái xác thực trong chế độ khách
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: currentIndex);
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
  }

  void _updateZoomState(int controllerIndex) {
    if (controllerIndex == currentIndex) {
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
    pageController.dispose();
    super.dispose();
  }

  GuardFileModel get currentImage => widget.images[currentIndex];

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

  Future<void> _setThumbnail(BuildContext context) async {
    try {
      final albumRepository = getIt<AlbumRepository>();
      final album = await albumRepository.getAlbumById(widget.albumId!);

      if (album == null) {
        throw Exception(AppStrings.albumNotFound);
      }

      final updatedAlbum = album.copyWith(
        fileThumbailPath: currentImage.filePath,
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

  Future<void> _editImage(BuildContext context) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProImageEditor.file(
            currentImage.filePath,
            callbacks: ProImageEditorCallbacks(
              onImageEditingComplete: (Uint8List bytes) async {
                try {
                  final file = File(currentImage.filePath);
                  await file.writeAsBytes(bytes);

                  // Clear image cache to force reload
                  PaintingBinding.instance.imageCache.clear();
                  PaintingBinding.instance.imageCache.clearLiveImages();

                  if (context.mounted) {
                    setState(() {
                      _imageRefreshKeys[currentImage.id] = DateTime.now().millisecondsSinceEpoch;
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.imageEdited)),
                    );

                    // Create updated file model and notify parent screen
                    final updatedFile = GuardFileModel(
                      id: currentImage.id,
                      albumId: currentImage.albumId,
                      filePath: currentImage.filePath,
                      type: currentImage.type,
                      createdAt: DateTime.now(), // Use current time to indicate modification
                    );
                    widget.onImageEdited?.call(updatedFile);
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

  @override
  Widget build(BuildContext context) {
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
                    await _setThumbnail(context);
                  } else if (value == 'edit_image') {
                    await _editImage(context);
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
                setState(() {
                  currentIndex = index;
                });
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
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Stack(
          children: [
            Image.file(
              File(file.filePath),
              key: ValueKey('${file.id}_${_imageRefreshKeys[file.id] ?? 0}_${file.createdAt.millisecondsSinceEpoch}'),
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.video_file,
                color: Colors.white,
                size: 80,
              ),
            ),
            // Show play button overlay
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
