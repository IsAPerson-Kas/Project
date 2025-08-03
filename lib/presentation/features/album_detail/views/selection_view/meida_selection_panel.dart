import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/features/album_detail/album_detail_cubit.dart';
import 'package:media_guard_v2/presentation/features/media_viewer/media_viewer_screen.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/confirm_dialog.dart';

class MediaSelectionPanel extends StatelessWidget {
  const MediaSelectionPanel({super.key, required this.cubit, required this.selectedFileIds, required this.totalFilesLenght});

  final AlbumDetailCubit cubit;
  final Set<int> selectedFileIds;
  final int totalFilesLenght;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSelectAllButton(context),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityValue(0.08),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          height: 210,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSelectionActions(context),
              ),
              Divider(
                height: 1,
                color: Colors.grey.withOpacityValue(0.2),
              ),
              _buildSelectionInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectAllButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacityValue(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      height: 34,
      width: 84,
      margin: const EdgeInsets.only(right: 4),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => cubit.toggleSelectAllFiles(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.all,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.check_circle,
              color: selectedFileIds.length == totalFilesLenght ? const Color(0xFF9447FF) : Colors.grey,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedFileIds.length} ${AppStrings.selected}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
          GestureDetector(
            onTap: () => cubit.exitSelectionMode(),
            child: Text(
              AppStrings.cancel,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionActions(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildSelectionActionItem(
            icon: Icons.share_outlined,
            label: AppStrings.share,
            onTap: () {
              Future.delayed(const Duration(milliseconds: 100), () {
                cubit.shareSelectedFiles();
              });
            },
          ),

          _buildSelectionActionItem(
            icon: Icons.download_outlined,
            label: AppStrings.download,
            onTap: () => _showDownLoadSelectedFilesConfirmation(context),
          ),

          if (cubit.albumModel != null && cubit.albumModel?.password != null)
            _buildSelectionActionItem(
              icon: Icons.lock_outline,
              label: AppStrings.guestMode,
              onTap: () {
                // Lấy danh sách các file được chọn
                if (cubit.state.status == AlbumDetailStatus.loaded) {
                  final state = cubit.state;
                  final selectedFiles = state.files.where((file) => selectedFileIds.contains(file.id)).toList();

                  if (selectedFiles.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaViewerScreen(
                          mediaFiles: selectedFiles,
                          initialIndex: 0,
                          albumId: cubit.albumId,
                          isGuestMode: true,
                          onMediaEdited: (editedFile) {},
                        ),
                      ),
                    );
                  }
                }
              },
            ),

          // _buildSelectionActionItem(
          //   icon: Icons.lock_outline,
          //   label: "Tạo ảnh ghép",
          //   onTap: () {},
          // ),
          _buildSelectionActionItem(
            icon: Icons.delete_outline,
            label: AppStrings.delete,
            onTap: () => _showDeleteSelectedFilesConfirmation(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 90,
      padding: const EdgeInsets.only(top: 24, left: 8, right: 18),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.black,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteSelectedFilesConfirmation(BuildContext context) {
    CommonDialog.showCustomDialog(
      child: ConfirmDialog(
        title: AppStrings.deleteSelectedFiles,
        message: AppStrings.deleteSelectedFilesConfirmation,
        confirmText: AppStrings.delete,
        onCancel: () => Navigator.pop(context),
        onConfirm: () {
          cubit.deleteSelectedFiles();
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showDownLoadSelectedFilesConfirmation(BuildContext context) {
    CommonDialog.showCustomDialog(
      child: ConfirmDialog(
        title: AppStrings.downloadImages,
        message: AppStrings.downloadImagesConfirmation,
        confirmText: AppStrings.download,
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          Navigator.pop(context);
          final success = await cubit.downloadSelectedFiles();
          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.downloadSuccess),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (!success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppStrings.downloadFailed),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
