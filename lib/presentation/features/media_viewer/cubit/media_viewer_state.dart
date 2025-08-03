part of 'media_viewer_cubit.dart';

enum MediaViewerStatus { initial, loaded, error }

class MediaViewerState extends Equatable {
  final MediaViewerStatus status;
  final int currentIndex;
  final bool isVideoPlaying;
  final String? errorMessage;

  const MediaViewerState({
    required this.status,
    required this.currentIndex,
    this.isVideoPlaying = false,
    this.errorMessage,
  });

  factory MediaViewerState.initial(int initialIndex) {
    return MediaViewerState(
      status: MediaViewerStatus.initial,
      currentIndex: initialIndex,
      isVideoPlaying: false,
    );
  }

  MediaViewerState copyWith({
    MediaViewerStatus? status,
    int? currentIndex,
    bool? isVideoPlaying,
    String? errorMessage,
  }) {
    return MediaViewerState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      isVideoPlaying: isVideoPlaying ?? this.isVideoPlaying,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, currentIndex, isVideoPlaying, errorMessage];
}
