part of 'album_list_cubit.dart';

sealed class AlbumListState extends Equatable {
  const AlbumListState();

  @override
  List<Object?> get props => [];
}

class AlbumListInitial extends AlbumListState {}

class AlbumListLoading extends AlbumListState {}

class AlbumListLoaded extends AlbumListState {
  final List<GuardAlbumModel> albums;

  const AlbumListLoaded(this.albums);

  AlbumListLoaded copyWith({
    List<GuardAlbumModel>? albums,
    bool? isCameraActive,
  }) {
    return AlbumListLoaded(
      albums ?? this.albums,
    );
  }

  @override
  List<Object?> get props => [albums];
}
