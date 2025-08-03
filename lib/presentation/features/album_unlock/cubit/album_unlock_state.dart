part of 'album_unlock_cubit.dart';

class AlbumUnlockState extends Equatable {
  final bool isCameraActive;
  final String? errorMessage;

  const AlbumUnlockState({
    this.isCameraActive = false,
    this.errorMessage,
  });

  AlbumUnlockState copyWith({
    bool? isCameraActive,
    String? errorMessage,
  }) {
    return AlbumUnlockState(
      isCameraActive: isCameraActive ?? this.isCameraActive,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isCameraActive,
    errorMessage,
  ];
}
