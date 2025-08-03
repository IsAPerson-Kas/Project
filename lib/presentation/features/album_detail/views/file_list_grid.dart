import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';

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
              _buildFileTypeIndicator(file),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2.0),
        child: Image.file(
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

  Widget _buildFileTypeIndicator(GuardFileModel file) {
    if (file.type == GuardFileType.video) {
      return Positioned(
        bottom: 4,
        right: 4,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 16,
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
