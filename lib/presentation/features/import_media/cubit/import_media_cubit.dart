import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:photo_manager/photo_manager.dart';

part "import_media_state.dart";

class ImportMediaCubit extends Cubit<ImportMediaState> {
  ImportMediaCubit() : super(const ImportMediaState());

  static const int _sizePerPage = 50;

  /// Initialize albums and load first page of assets
  Future<void> initializeAlbums() async {
    emit(state.copyWith(status: ImportMediaStatus.loading));

    try {
      // Request permissions
      final PermissionState ps = await PhotoManager.requestPermissionExtend();

      if (!ps.hasAccess) {
        emit(
          state.copyWith(
            status: ImportMediaStatus.error,
            errorMessage: AppStrings.permissionDenied,
          ),
        );
        return;
      }

      // Option 1: Lấy cả images và videos
      final PMFilter filter = FilterOptionGroup(
        imageOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
        videoOption: const FilterOption(
          sizeConstraint: SizeConstraint(ignoreSize: true),
        ),
      );

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: filter,
      );

      if (albums.isEmpty) {
        emit(
          state.copyWith(
            status: ImportMediaStatus.error,
            errorMessage: AppStrings.noAlbumsFound,
          ),
        );
        return;
      }

      // Set albums and load first album's assets
      emit(
        state.copyWith(
          status: ImportMediaStatus.loaded,
          albums: albums,
          selectedAlbumIndex: 0,
          entities: [],
          currentPage: 0,
          hasMoreToLoad: true,
        ),
      );

      await _loadAssetsForCurrentAlbum();
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportMediaStatus.error,
          errorMessage: '${AppStrings.failedToInitializeAlbums}: $e',
        ),
      );
      log('Error initializing albums: $e');
    }
  }

  /// Switch to a different album
  Future<void> switchAlbum(int albumIndex) async {
    if (albumIndex == state.selectedAlbumIndex || albumIndex >= state.albums.length || state.isLoadingMore) {
      return;
    }

    emit(
      state.copyWith(
        selectedAlbumIndex: albumIndex,
        entities: [],
        currentPage: 0,
        hasMoreToLoad: true,
      ),
    );

    await _loadAssetsForCurrentAlbum();
  }

  /// Load more assets (pagination)
  Future<void> loadMoreAssets() async {
    if (state.currentAlbum == null || state.isLoadingMore || !state.hasMoreToLoad) {
      return;
    }

    emit(state.copyWith(status: ImportMediaStatus.loadingMore));

    try {
      final List<AssetEntity> newAssets = await state.currentAlbum!.getAssetListPaged(
        page: state.currentPage,
        size: _sizePerPage,
      );

      final updatedEntities = List<AssetEntity>.from(state.entities)..addAll(newAssets);

      final hasMore = newAssets.length == _sizePerPage && updatedEntities.length < state.totalCount;

      emit(
        state.copyWith(
          status: ImportMediaStatus.loaded,
          entities: updatedEntities,
          currentPage: state.currentPage + 1,
          hasMoreToLoad: hasMore,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportMediaStatus.error,
          errorMessage: '${AppStrings.failedToLoadMoreAssets}: $e',
        ),
      );
      log('Error loading more assets: $e');
    }
  }

  /// Refresh current album
  Future<void> refresh() async {
    await initializeAlbums();
  }

  /// Load assets for currently selected album
  Future<void> _loadAssetsForCurrentAlbum() async {
    if (state.currentAlbum == null) return;

    try {
      // Get total count
      final int totalCount = await state.currentAlbum!.assetCountAsync;

      // Load first page
      final List<AssetEntity> entities = await state.currentAlbum!.getAssetListPaged(
        page: 0,
        size: _sizePerPage,
      );

      emit(
        state.copyWith(
          status: ImportMediaStatus.loaded,
          entities: entities,
          totalCount: totalCount,
          currentPage: 1, // Next page to load
          hasMoreToLoad: entities.length == _sizePerPage && entities.length < totalCount,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ImportMediaStatus.error,
          errorMessage: '${AppStrings.failedToLoadAlbumAssets}: $e',
        ),
      );
      log('Error loading album assets: $e');
    }
  }

  /// Get album name by index
  String getAlbumName(int index) {
    if (index >= 0 && index < state.albums.length) {
      return state.albums[index].name;
    }
    return AppStrings.unknownAlbum;
  }

  /// Get album asset count by index
  Future<int> getAlbumAssetCount(int index) async {
    if (index >= 0 && index < state.albums.length) {
      return await state.albums[index].assetCountAsync;
    }
    return 0;
  }
}
