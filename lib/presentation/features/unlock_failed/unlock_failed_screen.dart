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
          appBar: _buildAppBar(state),
          body: _buildBody(state),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(UnlockFailedState state) {
    return AppBar(
      title: state is UnlockFailedLoaded && state.isSelectionMode ? Text('${state.selectedFileIds.length} ${AppStrings.selected}') : Text(AppStrings.failedPassword),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        iconSize: 28,
        color: const Color(0xFF8B92A5),
        onPressed: () => Navigator.pop(context),
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      actions: _buildAppBarActions(state),
    );
  }

  List<Widget> _buildAppBarActions(UnlockFailedState state) {
    if (state is! UnlockFailedLoaded) return [];

    if (state.isSelectionMode) {
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          iconSize: 30,
          color: const Color(0xFF8B92A5),
          onPressed: () => context.read<UnlockFailedCubit>().selectAllFiles(),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          iconSize: 30,
          color: const Color(0xFF8B92A5),
          onPressed: () => _showDeleteSelectedFilesConfirmation(),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          iconSize: 30,
          color: const Color(0xFF8B92A5),
          onPressed: () => context.read<UnlockFailedCubit>().toggleSelectionMode(),
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.select_all),
          iconSize: 30,
          color: const Color(0xFF8B92A5),
          onPressed: () => context.read<UnlockFailedCubit>().toggleSelectionMode(),
        ),
      ];
    }
  }

  Widget _buildBody(UnlockFailedState state) {
    if (state is UnlockFailedLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is UnlockFailedError) {
      return Center(child: Text(state.message));
    }

    if (state is UnlockFailedLoaded) {
      if (state.files.isEmpty) {
        return Center(
          child: Text(AppStrings.noFailedAttemptsRecorded),
        );
      }

      return ListView.separated(
        itemCount: state.files.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
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
      child: Stack(
        children: [
          _buildFileContainer(file),
          _buildSelectionIndicator(file, state),
        ],
      ),
    );
  }

  Widget _buildFileContainer(GuardFileModel file) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: _buildFileThumbnail(file),
        title: _buildFileTitle(file),
      ),
    );
  }

  Widget _buildFileThumbnail(GuardFileModel file) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.file(
        File(file.filePath),
        width: 70,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacityValue(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.image_not_supported,
              size: 30,
              color: Theme.of(context).disabledColor,
            ),
          );
        },
      ),
    );
  }

  Widget _buildFileTitle(GuardFileModel file) {
    return Text(
      _dateFormat.format(file.createdAt),
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).textTheme.titleLarge?.color,
      ),
    );
  }

  Widget _buildSelectionIndicator(GuardFileModel file, UnlockFailedLoaded state) {
    if (!state.isSelectionMode || !state.selectedFileIds.contains(file.id)) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  void _handleFileTap(GuardFileModel file, UnlockFailedLoaded state) {
    if (state.isSelectionMode) {
      context.read<UnlockFailedCubit>().toggleFileSelection(file.id);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MediaViewerScreen(
            images: state.files,
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
