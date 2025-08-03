part of 'album_detail_cubit.dart';

enum AlbumDetailStatus {
  initial,
  loading,
  loaded,
  error,
}

class AlbumDetailState extends Equatable {
  final AlbumDetailStatus status;
  final List<GuardFileModel> files;
  final bool isSelectionMode;
  final Set<int> selectedFileIds;
  final bool canLoadMore;

  const AlbumDetailState({
    this.status = AlbumDetailStatus.initial,
    this.files = const [],
    this.isSelectionMode = false,
    this.selectedFileIds = const {},
    this.canLoadMore = true,
  });

  factory AlbumDetailState.initial() {
    return const AlbumDetailState(
      status: AlbumDetailStatus.initial,
      files: [],
      isSelectionMode: false,
      selectedFileIds: {},
      canLoadMore: true,
    );
  }

  factory AlbumDetailState.loading() {
    return const AlbumDetailState(
      status: AlbumDetailStatus.loading,
      files: [],
      isSelectionMode: false,
      selectedFileIds: {},
      canLoadMore: true,
    );
  }

  factory AlbumDetailState.loaded({
    required List<GuardFileModel> files,
    bool isSelectionMode = false,
    Set<int> selectedFileIds = const {},
    bool isCameraActive = false,
    required bool canLoadMore,
  }) {
    return AlbumDetailState(
      status: AlbumDetailStatus.loaded,
      files: files,
      isSelectionMode: isSelectionMode,
      selectedFileIds: selectedFileIds,
      canLoadMore: canLoadMore,
    );
  }

  factory AlbumDetailState.error({
    required String errorMessage,
    List<GuardFileModel> files = const [],
  }) {
    return AlbumDetailState(
      status: AlbumDetailStatus.error,
      files: files,
      canLoadMore: false,
    );
  }

  AlbumDetailState copyWith({
    AlbumDetailStatus? status,
    List<GuardFileModel>? files,
    bool? isSelectionMode,
    Set<int>? selectedFileIds,
    bool? isCameraActive,
    String? errorMessage,
    bool? canLoadMore,
  }) {
    return AlbumDetailState(
      status: status ?? this.status,
      files: files ?? this.files,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedFileIds: selectedFileIds ?? this.selectedFileIds,
      canLoadMore: canLoadMore ?? this.canLoadMore,
    );
  }

  @override
  List<Object?> get props => [
    status,
    files,
    isSelectionMode,
    selectedFileIds,
    canLoadMore,
  ];
}
