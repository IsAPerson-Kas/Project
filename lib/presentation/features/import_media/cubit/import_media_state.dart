part of "import_media_cubit.dart";

enum ImportMediaStatus {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class ImportMediaState extends Equatable {
  const ImportMediaState({
    this.status = ImportMediaStatus.initial,
    this.albums = const [],
    this.selectedAlbumIndex = 0,
    this.entities = const [],
    this.totalCount = 0,
    this.currentPage = 0,
    this.hasMoreToLoad = true,
    this.errorMessage,
  });

  final ImportMediaStatus status;
  final List<AssetPathEntity> albums;
  final int selectedAlbumIndex;
  final List<AssetEntity> entities;
  final int totalCount;
  final int currentPage;
  final bool hasMoreToLoad;
  final String? errorMessage;

  // Getters for convenience
  AssetPathEntity? get currentAlbum => albums.isNotEmpty ? albums[selectedAlbumIndex] : null;

  bool get isInitializing => status == ImportMediaStatus.loading;
  bool get isLoadingMore => status == ImportMediaStatus.loadingMore;
  bool get hasError => status == ImportMediaStatus.error;
  bool get hasData => status == ImportMediaStatus.loaded;

  ImportMediaState copyWith({
    ImportMediaStatus? status,
    List<AssetPathEntity>? albums,
    int? selectedAlbumIndex,
    List<AssetEntity>? entities,
    int? totalCount,
    int? currentPage,
    bool? hasMoreToLoad,
    String? errorMessage,
  }) {
    return ImportMediaState(
      status: status ?? this.status,
      albums: albums ?? this.albums,
      selectedAlbumIndex: selectedAlbumIndex ?? this.selectedAlbumIndex,
      entities: entities ?? this.entities,
      totalCount: totalCount ?? this.totalCount,
      currentPage: currentPage ?? this.currentPage,
      hasMoreToLoad: hasMoreToLoad ?? this.hasMoreToLoad,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    albums,
    selectedAlbumIndex,
    entities,
    totalCount,
    currentPage,
    hasMoreToLoad,
    errorMessage,
  ];
}
