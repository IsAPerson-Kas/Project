import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/utils/password_hasher.dart';
import 'package:media_guard_v2/data/datasources/local_database/tables/guard_file.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';

part 'album_unlock_state.dart';

class AlbumUnlockCubit extends Cubit<AlbumUnlockState> {
  final AlbumRepository _albumRepository;
  final FileRepository _fileRepository;

  AlbumUnlockCubit({
    required AlbumRepository albumRepository,
    required FileRepository fileRepository,
  }) : _albumRepository = albumRepository,
       _fileRepository = fileRepository,
       super(const AlbumUnlockState());

  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  Future<void> startCamera() async {
    if (_isCameraInitialized) return;

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      // Find front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _isCameraInitialized = true;

      emit(state.copyWith(isCameraActive: true));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> pauseCamera() async {
    if (_cameraController != null && _isCameraInitialized) {
      try {
        await _cameraController!.pausePreview();
        emit(state.copyWith(isCameraActive: false));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> resumeCamera() async {
    if (_cameraController != null && _isCameraInitialized) {
      try {
        await _cameraController!.resumePreview();
        emit(state.copyWith(isCameraActive: true));
      } catch (e) {
        emit(state.copyWith(errorMessage: e.toString()));
      }
    }
  }

  Future<void> disposeCamera() async {
    if (_cameraController != null) {
      await _cameraController!.dispose();
      _cameraController = null;
      _isCameraInitialized = false;

      emit(state.copyWith(isCameraActive: false));
    }
  }

  Future<String?> captureImage() async {
    if (_cameraController == null || !_isCameraInitialized) return null;

    try {
      final image = await _cameraController!.takePicture();
      return image.path;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return null;
    }
  }

  Future<bool> validateAlbumPassword(String password, int albumId) async {
    try {
      final album = await _albumRepository.getAlbumById(albumId);

      final hashedPassword = PasswordHasher.hash(password);
      return album != null && album.password == hashedPassword;
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
      return false;
    }
  }

  Future<void> saveFailedAttemptImage(String imagePath) async {
    try {
      await _fileRepository.addFile(albumId: 0, filePath: imagePath, type: GuardFileType.image);
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
