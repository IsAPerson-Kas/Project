import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/presentation/features/media_viewer/media_viewer_screen.dart';
import 'package:media_guard_v2/presentation/features/unlock_failed/unlock_failed_cubit.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/confirm_dialog.dart';

class UnlockFailedScreen extends StatefulWidget {
  const UnlockFailedScreen({super.key});

  @override
  State<UnlockFailedScreen> createState() => _UnlockFailedScreenState();
}

class _UnlockFailedScreenState extends State<UnlockFailedScreen> {
  final _dateFormat = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    context.read<UnlockFailedCubit>().loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UnlockFailedCubit, UnlockFailedState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: _buildAppBar(state),
          body: _buildBody(state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(UnlockFailedState state) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: state is UnlockFailedLoaded && state.isSelectionMode
          ? Text(
              '${state.selectedFileIds.length} ${AppStrings.selected}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            )
          : Text(
              AppStrings.failedPassword,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        iconSize: 28,
        onPressed: () => Navigator.pop(context),
      ),
      actions: _buildAppBarActions(state),
    );
  }

  List<Widget> _buildAppBarActions(UnlockFailedState state) {
    if (state is! UnlockFailedLoaded) return [];

    if (state.isSelectionMode) {
      return [
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.black87),
          iconSize: 28,
          onPressed: () => context.read<UnlockFailedCubit>().selectAllFiles(),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          iconSize: 28,
          onPressed: () => _showDeleteSelectedFilesConfirmation(),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.grey),
          iconSize: 28,
          onPressed: () => context.read<UnlockFailedCubit>().toggleSelectionMode(),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.select_all, color: Colors.black87),
          iconSize: 28,
          onPressed: () => context.read<UnlockFailedCubit>().toggleSelectionMode(),
        ),
      ];
    }
  }

  Widget _buildBody(UnlockFailedState state) {
    if (state is UnlockFailedLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
        ),
      );
    }

    if (state is UnlockFailedError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is UnlockFailedLoaded) {
      if (state.files.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacityValue(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.security,
                  size: 64,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.noFailedAttemptsRecorded,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Không có lần thử thất bại nào được ghi lại',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: state.files.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, index) {
          final file = state.files[index];
          return _buildFileItem(file, state);
        },
        physics: const BouncingScrollPhysics(),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildFileItem(GuardFileModel file, UnlockFailedLoaded state) {
    return GestureDetector(
      onTap: () => _handleFileTap(file, state),
      onLongPress: () => _handleFileLongPress(file, state),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacityValue(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildFileContainer(file),
      ),
    );
  }

  Widget _buildFileContainer(GuardFileModel file) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _buildFileThumbnail(file),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFileTitle(file),
                const SizedBox(height: 2),
                _buildFileSubtitle(file),
              ],
            ),
          ),
          _buildSelectionIndicator(file, context.read<UnlockFailedCubit>().state),
        ],
      ),
    );
  }

  Widget _buildFileThumbnail(GuardFileModel file) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityValue(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(file.filePath),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFECF0F1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.image_not_supported,
                size: 24,
                color: Colors.grey[400],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFileTitle(GuardFileModel file) {
    return Text(
      _dateFormat.format(file.createdAt),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildFileSubtitle(GuardFileModel file) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.red.withOpacityValue(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.security,
                size: 12,
                color: Colors.red,
              ),
              const SizedBox(width: 3),
              Text(
                'Lần thử thất bại',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator(GuardFileModel file, UnlockFailedState state) {
    if (state is! UnlockFailedLoaded) return const SizedBox.shrink();

    if (!state.isSelectionMode) {
      return const SizedBox.shrink();
    }

    if (state.selectedFileIds.contains(file.id)) {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFF9447FF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 14,
        ),
      );
    } else {
      return Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          shape: BoxShape.circle,
        ),
      );
    }
  }

  void _handleFileTap(GuardFileModel file, UnlockFailedLoaded state) {
    if (state.isSelectionMode) {
      context.read<UnlockFailedCubit>().toggleFileSelection(file.id);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaViewerScreen(
            mediaFiles: state.files,
            initialIndex: state.files.indexWhere((f) => f.id == file.id),
            albumId: file.albumId,
            onMediaEdited: (editedFile) {
              context.read<UnlockFailedCubit>().updateEditedImage(editedFile);
            },
          ),
        ),
      );
    }
  }

  void _handleFileLongPress(GuardFileModel file, UnlockFailedLoaded state) {
    if (!state.isSelectionMode) {
      context.read<UnlockFailedCubit>().toggleSelectionMode();
      context.read<UnlockFailedCubit>().toggleFileSelection(file.id);
    }
  }

  void _showDeleteSelectedFilesConfirmation() {
    CommonDialog.showCustomDialog(
      child: ConfirmDialog(
        title: AppStrings.deleteSelectedFiles,
        message: AppStrings.deleteSelectedFilesConfirmation,
        confirmText: AppStrings.delete,
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          await context.read<UnlockFailedCubit>().deleteSelectedFiles();
          if (mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
