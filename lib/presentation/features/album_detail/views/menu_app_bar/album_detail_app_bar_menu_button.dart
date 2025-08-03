import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/presentation/features/album_detail/album_detail_cubit.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/album_unlock_navigator.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/confirm_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/text_field_dialog.dart';

enum AlbumDetailAppBarMenuAction {
  rename,
  addPassword,
  removePassword,
  delete,
}

class AlbumDetailAppBarMenuButton extends StatefulWidget {
  const AlbumDetailAppBarMenuButton({super.key, required this.cubit});

  final AlbumDetailCubit cubit;

  @override
  State<AlbumDetailAppBarMenuButton> createState() => _AlbumDetailAppBarMenuButtonState();
}

class _AlbumDetailAppBarMenuButtonState extends State<AlbumDetailAppBarMenuButton> {
  bool? _hasPassword;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPasswordStatus();
    });
  }

  Future<void> _checkPasswordStatus() async {
    final album = await widget.cubit.getAlbum();
    if (!mounted) return;
    setState(() {
      _hasPassword = album?.password != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AlbumDetailAppBarMenuAction>(
      icon: const Icon(
        Icons.more_vert,
        size: 30,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 8,
      padding: EdgeInsets.zero,

      onSelected: (value) {
        _handlePopupMenuSelection(value);
      },
      itemBuilder: (context) => _buildPopupMenuItems(),
    );
  }

  List<PopupMenuEntry<AlbumDetailAppBarMenuAction>> _buildPopupMenuItems() {
    return [
      PopupMenuItem(
        value: AlbumDetailAppBarMenuAction.rename,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 40,
        child: Row(
          children: [
            const Icon(Icons.edit, color: Color(0xFF8B92A5), size: 20),
            const SizedBox(width: 8),
            Text(
              AppStrings.renameAlbum,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
      if (_hasPassword != null)
        PopupMenuItem(
          value: _hasPassword == true ? AlbumDetailAppBarMenuAction.removePassword : AlbumDetailAppBarMenuAction.addPassword,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          height: 40,
          child: Row(
            children: [
              Icon(
                _hasPassword == true ? Icons.lock_open : Icons.lock,
                color: const Color(0xFF8B92A5),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _hasPassword == true ? AppStrings.removePassword : AppStrings.addPassword,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      const PopupMenuDivider(height: 1),
      PopupMenuItem(
        value: AlbumDetailAppBarMenuAction.delete,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 40,
        child: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            const SizedBox(width: 8),
            Text(
              AppStrings.deleteAlbum,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  void _handlePopupMenuSelection(AlbumDetailAppBarMenuAction value) async {
    switch (value) {
      case AlbumDetailAppBarMenuAction.rename:
        _showRenameDialog();
        break;
      case AlbumDetailAppBarMenuAction.delete:
        _showDeleteConfirmation();
        break;
      case AlbumDetailAppBarMenuAction.addPassword:
        _showAddPasswordDialog();
        break;
      case AlbumDetailAppBarMenuAction.removePassword:
        _showRemovePasswordDialog();
        break;
    }
  }

  void _showRenameDialog() {
    final TextEditingController controller = TextEditingController(text: widget.cubit.albumName);
    CommonDialog.showCustomDialog(
      child: TextFieldDialog(
        title: AppStrings.renameAlbum,
        activeButtonText: AppStrings.rename,
        controller: controller,
        hintText: AppStrings.enterNewAlbumName,
        onCancel: () => Navigator.pop(context),
        onActive: (text) async {
          if (text.isNotEmpty && text != widget.cubit.albumName) {
            final success = await widget.cubit.renameAlbum(text);
            if (!mounted) return;
            Navigator.pop(context);
            if (success) {
              Navigator.pop(context, 'renamed');
            }
          } else {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showAddPasswordDialog() {
    AlbumUnlockNavigator.navigateToAlbumUnlock(
      AlbumUnlockNavigatorParams(
        title: AppStrings.createPassword,
        mode: AlbumUnlockMode.create,
        onCreated: (String password) async {
          final success = await widget.cubit.setPassword(password);
          if (success) {
            setState(() {
              _hasPassword = true;
            });
          }
        },
        onCancel: () {
          // Handle cancel if needed
        },
      ),
    );
  }

  void _showDeleteConfirmation() {
    if (_hasPassword == null) {
      return;
    }
    if (_hasPassword == true) {
      _showDeleteWithPasswordDialog();
    } else {
      _showDeleteWithoutPasswordDialog();
    }
  }

  void _showDeleteWithoutPasswordDialog() {
    CommonDialog.showCustomDialog(
      child: ConfirmDialog(
        title: AppStrings.deleteAlbum,
        message: AppStrings.deleteAlbumConfirmation,
        confirmText: AppStrings.delete,
        onCancel: () => Navigator.pop(context),
        onConfirm: () async {
          final success = await widget.cubit.deleteAlbum();
          if (!mounted) return;
          Navigator.pop(context);
          if (success) {
            Navigator.pop(context, 'deleted');
          }
        },
      ),
    );
  }

  void _showDeleteWithPasswordDialog() {
    AlbumUnlockNavigator.navigateToAlbumUnlock(
      AlbumUnlockNavigatorParams(
        title: AppStrings.deleteAlbum,
        mode: AlbumUnlockMode.unlock,
        onComplete: (bool success) async {
          if (success) {
            final result = await widget.cubit.deleteAlbumWithPassword(true);
            if (result && mounted) {
              Navigator.pop(context, 'deleted');
            }
          }
        },
        onCancel: () {
          // Handle cancel if needed
        },
      ),
    );
  }

  void _showRemovePasswordDialog() {
    AlbumUnlockNavigator.navigateToAlbumUnlock(
      AlbumUnlockNavigatorParams(
        title: AppStrings.removePassword,
        mode: AlbumUnlockMode.unlock,
        onComplete: (bool success) async {
          if (success) {
            final result = await widget.cubit.removePassword(true);
            if (result) {
              // Verify the password was actually removed
              final album = await widget.cubit.getAlbum();
              if (!mounted) return;

              if (album?.password == null) {
                setState(() {
                  _hasPassword = false;
                });
                Navigator.pop(context, 'removePassword');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppStrings.failedToRemovePassword)),
                );
              }
            }
          }
        },
        onCancel: () {
          // Handle cancel if needed
        },
      ),
    );
  }
}
