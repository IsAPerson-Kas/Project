import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/main.dart';

part 'unlock_failed_state.dart';

class UnlockFailedCubit extends Cubit<UnlockFailedState> {
  final _fileRepository = getIt<FileRepository>();

  UnlockFailedCubit() : super(UnlockFailedInitial());

  Future<void> loadFiles() async {
    emit(UnlockFailedLoading());
    try {
      final files = await _fileRepository.getFilesByAlbum(0);
      emit(UnlockFailedLoaded(files: files));
    } catch (e) {
      emit(UnlockFailedError(message: e.toString()));
    }
  }

  void toggleSelectionMode() {
    if (state is UnlockFailedLoaded) {
      final currentState = state as UnlockFailedLoaded;
      emit(
        currentState.copyWith(
          isSelectionMode: !currentState.isSelectionMode,
          selectedFileIds: !currentState.isSelectionMode ? {} : currentState.selectedFileIds,
        ),
      );
    }
  }

  void toggleFileSelection(int fileId) {
    if (state is UnlockFailedLoaded) {
      final currentState = state as UnlockFailedLoaded;
      final newSelectedIds = Set<int>.from(currentState.selectedFileIds);

      if (newSelectedIds.contains(fileId)) {
        newSelectedIds.remove(fileId);
      } else {
        newSelectedIds.add(fileId);
      }

      emit(currentState.copyWith(selectedFileIds: newSelectedIds));
    }
  }

  void selectAllFiles() {
    if (state is UnlockFailedLoaded) {
      final currentState = state as UnlockFailedLoaded;
      final allFileIds = currentState.files.map((file) => file.id).toSet();
      emit(currentState.copyWith(selectedFileIds: allFileIds));
    }
  }

  /// Update a specific edited image in the current state
  void updateEditedImage(GuardFileModel editedFile) {
    if (state is UnlockFailedLoaded) {
      final currentState = state as UnlockFailedLoaded;
      final updatedFiles = currentState.files.map<GuardFileModel>((f) {
        if (f.id == editedFile.id) {
          return editedFile;
        }
        return f;
      }).toList();
      emit(
        UnlockFailedLoaded(
          files: updatedFiles,
          isSelectionMode: currentState.isSelectionMode,
          selectedFileIds: currentState.selectedFileIds,
        ),
      );
    }
  }

  Future<void> deleteSelectedFiles() async {
    if (state is UnlockFailedLoaded) {
      final currentState = state as UnlockFailedLoaded;
      try {
        for (final fileId in currentState.selectedFileIds) {
          // Get file info before deleting from database
          final file = currentState.files.firstWhere((f) => f.id == fileId);

          // Delete physical file from storage
          final fileToDelete = File(file.filePath);
          if (await fileToDelete.exists()) {
            await fileToDelete.delete();
          }

          // Delete file record from database using repository
          await _fileRepository.deleteFile(fileId);
        }
        await loadFiles();
        emit(
          (state as UnlockFailedLoaded).copyWith(
            isSelectionMode: false,
            selectedFileIds: {},
          ),
        );
      } catch (e) {
        emit(UnlockFailedError(message: e.toString()));
      }
    }
  }
}
