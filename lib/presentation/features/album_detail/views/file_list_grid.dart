import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FileListGrid extends StatelessWidget {
  final List<GuardFileModel> files;
  final bool isSelectionMode;
  final Set<int> selectedFileIds;
  final Function(GuardFileModel) onFileTap;
  final Function(GuardFileModel) onFileLongPress;
  final ScrollController? scrollController;

  const FileListGrid({
    super.key,
    required this.files,
    required this.isSelectionMode,
    required this.selectedFileIds,
    required this.onFileTap,
    required this.onFileLongPress,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1.0,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: files.length,
      padding: EdgeInsets.only(
        bottom: isSelectionMode ? 250.0 : MediaQuery.of(context).padding.bottom,
      ),
      itemBuilder: (context, index) {
        final file = files[index];
        return _buildFileItem(file);
      },
      physics: const BouncingScrollPhysics(),
    );
  }

  Widget _buildFileItem(GuardFileModel file) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return GestureDetector(
          onTap: () => onFileTap(file),
          onLongPress: () => onFileLongPress(file),
          child: Stack(
            children: [
              _buildFileImage(file),
              _buildFileSelectionIndicator(file, size),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFileImage(GuardFileModel file) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
      ),
      alignment: Alignment.center,
      child: Stack(
        children: [
          if (file.type == GuardFileType.video)
            FutureBuilder<String?>(
              future: () async {
                final tempDir = await getTemporaryDirectory();
                return VideoThumbnail.thumbnailFile(
                  video: file.filePath,
                  thumbnailPath: tempDir.path,
                  imageFormat: ImageFormat.JPEG,
                  maxHeight: 400,
                  quality: 75,
                );
              }(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Image.file(
                    File(snapshot.data!),
                    width: double.infinity,
                    height: double.infinity,
                    cacheWidth: 400,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.video_file, size: 30, color: Colors.white),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Icon(Icons.video_file, size: 30, color: Colors.white),
                  );
                }
              },
            )
          else
            Image.file(
              File(file.filePath),
              width: double.infinity,
              height: double.infinity,
              cacheWidth: 400,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.image_not_supported, size: 30),
                );
              },
            ),
          // Show play button overlay for video files
          if (file.type == GuardFileType.video)
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFileSelectionIndicator(GuardFileModel file, double size) {
    if (isSelectionMode && selectedFileIds.contains(file.id)) {
      return Positioned(
        top: size / 2 - 10,
        right: size / 2 - 10,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Color(0xFF9447FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 16,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
