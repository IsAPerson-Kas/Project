import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/events/app_event_stream.dart';
import 'package:media_guard_v2/core/native/native_share.dart';
import 'package:media_guard_v2/core/utils/password_hasher.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/error_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';

part 'album_detail_state.dart';

class AlbumDetailCubit extends Cubit<AlbumDetailState> {
  final String albumName;
  final int albumId;
  final AlbumRepository albumRepository;
  final FileRepository fileRepository;

  AlbumDetailCubit({
    required this.albumRepository,
    required this.fileRepository,
    required this.albumName,
    required this.albumId,
  }) : super(AlbumDetailState.initial());

  GuardAlbumModel? _albumModel;
  GuardAlbumModel? get albumModel => _albumModel;

  // ==================== INITIALIZATION ====================
  Future<void> initialize() async {
    _albumModel = await getAlbum();
    await loadFiles();
  }

  // ==================== FILE MANAGEMENT ====================

  /// Load all files in the album
  Future<void> loadFiles({bool isAppend = false, int pageSize = 60}) async {
    List<GuardFileModel> currentFiles = [];
    if (state.status == AlbumDetailStatus.loaded && isAppend) {
      currentFiles = state.files;
    } else {
      emit(AlbumDetailState.loading());
    }

    final int offset = currentFiles.length;
    try {
      final files = await fileRepository.getFilesPaged(
        albumId,
        offset,
        pageSize,
      );
      final allFiles = [...currentFiles, ...files];
      emit(
        AlbumDetailState.loaded(
          files: allFiles,
          canLoadMore: files.length == pageSize,
        ),
      );
    } catch (e) {
      emit(AlbumDetailState.error(errorMessage: e.toString()));
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to load files: ${e.toString()}",
          onClose: () {},
        ),
      );
    }
  }

  /// Add files to the album
  Future<void> addFiles(List<String> assetIds) async {
    try {
      final List<AssetEntity> assets = [];
      for (final id in assetIds) {
        final asset = await AssetEntity.fromId(id);
        if (asset != null) {
          assets.add(asset);
        }
      }

      final appDir = await getApplicationDocumentsDirectory();
      final albumDir = Directory('${appDir.path}/$albumId');
      if (!await albumDir.exists()) {
        await albumDir.create(recursive: true);
      }

      for (final asset in assets) {
        final file = await asset.file;
        if (file != null) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}_${asset.id}.${file.path.split('.').last}';
          final newPath = '${albumDir.path}/$fileName';

          // Copy the file to app's private storage
          await file.copy(newPath);

          // Determine file type based on asset type
          GuardFileType fileType = GuardFileType.image;
          if (asset.type == AssetType.video) {
            fileType = GuardFileType.video;
          }

          // Create GuardFile entry
          await fileRepository.addFile(
            albumId: albumId,
            filePath: newPath,
            type: fileType,
          );
        }
      }

      await loadFiles();
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to add files: ${e.toString()}",
          onClose: () {},
        ),
      );
    }
  }

  /// Delete selected files from the album
  Future<bool> deleteSelectedFiles() async {
    if (state.status == AlbumDetailStatus.loaded) {
      try {
        for (final fileId in state.selectedFileIds) {
          final file = state.files.firstWhere((f) => f.id == fileId);

          // Delete physical file
          final fileToDelete = File(file.filePath);
          if (await fileToDelete.exists()) {
            await fileToDelete.delete();
          }

          // Delete from database
          await fileRepository.deleteFile(fileId);
        }

        await loadFiles();
        return true;
      } catch (e) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Failed to delete files: ${e.toString()}",
            onClose: () {},
          ),
        );
        return false;
      }
    }
    return false;
  }

  /// Share selected files
  Future<void> shareSelectedFiles() async {
    if (state.status != AlbumDetailStatus.loaded) return;
    final filesToShare = state.selectedFileIds.map((id) => state.files.firstWhere((f) => f.id == id)).map((f) => File(f.filePath)).where((f) => f.existsSync()).toList();
    if (filesToShare.isEmpty) return;
    await NativeShare.shareFiles(filesToShare, text: AppStrings.greatPicture);
  }

  Future<bool> downloadSelectedFiles() async {
    if (state.status == AlbumDetailStatus.loaded) {
      try {
        final permission = await PhotoManager.requestPermissionExtend();
        if (!permission.hasAccess) {
          PhotoManager.openSetting();
          return false;
        }

        int successCount = 0;
        for (final fileId in state.selectedFileIds) {
          final file = state.files.firstWhere((f) => f.id == fileId);

          final filetoDownload = File(file.filePath);
          if (!await filetoDownload.exists()) continue;

          final bytes = await filetoDownload.readAsBytes();
          final fileName = filetoDownload.uri.pathSegments.last;
          await PhotoManager.editor.saveImage(
            bytes,
            filename: fileName,
            relativePath: 'Pictures/PhotoGuard',
          );
          successCount++;
        }

        await loadFiles();
        return successCount > 0;
      } catch (e) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Failed to download files: ${e.toString()}",
            onClose: () {},
          ),
        );
        return false;
      }
    }
    return false;
  }

  /// Update a specific edited image in the current state
  void updateEditedImage(GuardFileModel editedFile) {
    if (state.status == AlbumDetailStatus.loaded) {
      final updatedFiles = state.files.map<GuardFileModel>((f) {
        if (f.id == editedFile.id) {
          return editedFile;
        }
        return f;
      }).toList();
      emit(
        state.copyWith(
          files: updatedFiles,
        ),
      );
    }
  }

  // ==================== ALBUM MANAGEMENT ====================

  /// Get album information
  Future<GuardAlbumModel?> getAlbum() async {
    try {
      return await albumRepository.getAlbumById(albumId);
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to get album: ${e.toString()}",
          onClose: () {},
        ),
      );
      return null;
    }
  }

  /// Rename the album
  Future<bool> renameAlbum(String newName) async {
    try {
      final album = await getAlbum();
      if (album == null) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Album not found",
            onClose: () {},
          ),
        );
        return false;
      }
      final success = await albumRepository.updateAlbum(
        album.copyWith(
          name: newName,
          password: album.password,
          fileThumbailPath: album.fileThumbailPath,
        ),
      );

      if (success) {
        // Get updated album and emit event
        final updatedAlbum = await albumRepository.getAlbumById(albumId);
        if (updatedAlbum != null) {
          AppEventStream().albumUpdated(updatedAlbum);
        }
      }

      return success;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to rename album: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  /// Delete the entire album
  Future<bool> deleteAlbum() async {
    try {
      // Delete all files in the album first
      final files = await fileRepository.getFilesByAlbum(albumId);
      for (final file in files) {
        // Delete physical file from storage
        final fileToDelete = File(file.filePath);
        if (await fileToDelete.exists()) {
          await fileToDelete.delete();
        }
        // Delete file record from database
        await fileRepository.deleteFile(file.id);
      }

      // Then delete the album from database
      final success = await albumRepository.deleteAlbum(albumId);
      if (success) {
        // Emit event for album deletion
        AppEventStream().albumDeleted(albumId);
      }
      return success;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to delete album: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  /// Delete album with password verification
  Future<bool> deleteAlbumWithPassword(bool isAuthenticated) async {
    try {
      final album = await albumRepository.getAlbumById(albumId);
      if (album == null) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Album not found",
            onClose: () {},
          ),
        );
        return false;
      }

      // If authenticated, proceed with deletion
      if (isAuthenticated) {
        await deleteAlbum();
        return true;
      }
      return false;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to delete album: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  // ==================== PASSWORD MANAGEMENT ====================

  /// Set password for the album
  Future<bool> setPassword(String password) async {
    try {
      final album = await albumRepository.getAlbumById(albumId);
      if (album == null) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Album not found",
            onClose: () {},
          ),
        );
        return false;
      }

      final hashedPassword = PasswordHasher.hash(password);

      final result = await albumRepository.updateAlbum(
        album.copyWith(
          password: hashedPassword,
          fileThumbailPath: album.fileThumbailPath,
        ),
      );

      if (result) {
        // Get updated album and emit event
        final updatedAlbum = await albumRepository.getAlbumById(albumId);
        if (updatedAlbum != null) {
          AppEventStream().albumUpdated(updatedAlbum);
        }
      }

      return result;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to set password: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  /// Change album password
  Future<bool> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      final album = await albumRepository.getAlbumById(albumId);
      if (album == null) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Album not found",
            onClose: () {},
          ),
        );
        return false;
      }

      final hashedCurrentPassword = PasswordHasher.hash(currentPassword);

      if (album.password == hashedCurrentPassword) {
        final hashedNewPassword = PasswordHasher.hash(newPassword);

        final result = await albumRepository.updateAlbum(
          album.copyWith(
            password: hashedNewPassword,
            fileThumbailPath: album.fileThumbailPath,
          ),
        );

        if (result) {
          // Get updated album and emit event
          final updatedAlbum = await albumRepository.getAlbumById(albumId);
          if (updatedAlbum != null) {
            AppEventStream().albumUpdated(updatedAlbum);
          }
        }

        return result;
      } else {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Incorrect password",
            onClose: () {},
          ),
        );
      }
      return false;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to change password: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  /// Remove password from album
  Future<bool> removePassword(bool isAuthenticated) async {
    try {
      final album = await albumRepository.getAlbumById(albumId);
      if (album == null) {
        CommonDialog.showCustomDialog(
          child: ErrorDialog(
            title: "Error",
            message: "Album not found",
            onClose: () {},
          ),
        );
        return false;
      }

      // If authenticated, proceed with password removal
      if (isAuthenticated) {
        final result = await albumRepository.updateAlbum(
          album.copyWith(
            password: null,
            fileThumbailPath: album.fileThumbailPath,
          ),
        );

        if (result) {
          // Get updated album and emit event
          final updatedAlbum = await albumRepository.getAlbumById(albumId);
          if (updatedAlbum != null) {
            AppEventStream().albumUpdated(updatedAlbum);
          }
        }

        return result;
      }
      return false;
    } catch (e) {
      CommonDialog.showCustomDialog(
        child: ErrorDialog(
          title: "Error",
          message: "Failed to remove password: ${e.toString()}",
          onClose: () {},
        ),
      );
      return false;
    }
  }

  // ==================== SELECTION MODE MANAGEMENT ====================

  /// Exit selection mode
  void exitSelectionMode() {
    if (state.status == AlbumDetailStatus.loaded) {
      emit(
        state.copyWith(
          isSelectionMode: false,
          selectedFileIds: {},
        ),
      );
    }
  }

  /// Toggle selection for a specific file
  void toggleSelectionFile(int fileId) {
    if (state.status == AlbumDetailStatus.loaded) {
      final newSelectedIds = Set<int>.from(state.selectedFileIds);

      if (newSelectedIds.contains(fileId)) {
        newSelectedIds.remove(fileId);
      } else {
        newSelectedIds.add(fileId);
      }

      emit(
        state.copyWith(
          selectedFileIds: newSelectedIds,
          isSelectionMode: newSelectedIds.isNotEmpty,
        ),
      );
    }
  }

  /// Toggle select all files
  void toggleSelectAllFiles() {
    if (state.status == AlbumDetailStatus.loaded) {
      if (state.selectedFileIds.length == state.files.length) {
        emit(state.copyWith(selectedFileIds: {}, isSelectionMode: false));
        return;
      }

      final allFileIds = state.files.map((file) => file.id).toSet();
      emit(state.copyWith(selectedFileIds: allFileIds));
    }
  }
}
