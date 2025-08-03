part of "media_viewer_cubit.dart";

class MediaViewerState extends Equatable {
  final int currentIndex;
  final MediaViewerStatus status;
  final String? errorMessage;

  const MediaViewerState({
    required this.currentIndex,
    this.status = MediaViewerStatus.initial,
    this.errorMessage,
  });

  factory MediaViewerState.initial(int initialIndex) {
    return MediaViewerState(currentIndex: initialIndex);
  }

  MediaViewerState copyWith({
    int? currentIndex,
    MediaViewerStatus? status,
    String? errorMessage,
  }) {
    return MediaViewerState(
      currentIndex: currentIndex ?? this.currentIndex,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [currentIndex, status, errorMessage];
}
