import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/utils/delete_file_util.dart';
import 'package:media_guard_v2/domain/models/guard_file_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:media_guard_v2/presentation/features/album_detail/album_detail_cubit.dart';
import 'package:media_guard_v2/presentation/features/album_detail/views/file_list_grid.dart';
import 'package:media_guard_v2/presentation/features/album_detail/views/menu_app_bar/album_detail_app_bar_menu_button.dart';
import 'package:media_guard_v2/presentation/features/album_detail/views/selection_view/meida_selection_panel.dart';
import 'package:media_guard_v2/presentation/features/media_viewer/media_viewer_screen.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class AlbumDetailScreen extends StatefulWidget {
  final String albumName;
  final int albumId;

  const AlbumDetailScreen({
    super.key,
    required this.albumName,
    required this.albumId,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  late final ScrollController _scrollController;
  final int _pageSize = 60;
  bool _isLoading = false;
  bool _isAddingFiles = false;

  late final AlbumDetailCubit _cubit = AlbumDetailCubit(
    albumId: widget.albumId,
    albumName: widget.albumName,
    albumRepository: getIt<AlbumRepository>(),
    fileRepository: getIt<FileRepository>(),
  )..initialize();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadFiles();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final state = _cubit.state;
      if (state.status == AlbumDetailStatus.loaded && !_isLoading && state.canLoadMore) {
        _isLoading = true;
        _cubit
            .loadFiles(
              pageSize: _pageSize,
              isAppend: true,
            )
            .then((_) {
              _isLoading = false;
            });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  // ==================== UI BUILDING METHODS ====================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(widget.albumName),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        iconSize: 28,
        color: Colors.black,
        onPressed: () => Navigator.pop(context, 'back'),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
          buildWhen: (previous, current) {
            if (previous.status == AlbumDetailStatus.loaded && current.status == AlbumDetailStatus.loaded) {
              return previous.isSelectionMode != current.isSelectionMode;
            }
            return previous.status != current.status;
          },
          builder: (context, state) {
            if (state.status == AlbumDetailStatus.loaded) {
              return state.isSelectionMode ? SizedBox.shrink() : AlbumDetailAppBarMenuButton(cubit: _cubit);
            }
            return SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
      buildWhen: (previous, current) {
        if (previous.status == AlbumDetailStatus.loaded && current.status == AlbumDetailStatus.loaded) {
          return previous.isSelectionMode != current.isSelectionMode || previous.selectedFileIds.length != current.selectedFileIds.length;
        }
        return previous.status != current.status;
      },
      builder: (context, state) {
        final isShowingSelectionPanel = state.status == AlbumDetailStatus.loaded && state.isSelectionMode;
        return Stack(
          children: [
            _buildMainContent(),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              left: 0,
              right: 0,
              bottom: isShowingSelectionPanel ? 0 : -248,
              child: MediaSelectionPanel(
                cubit: _cubit,
                selectedFileIds: state.status == AlbumDetailStatus.loaded ? state.selectedFileIds : {},
                totalFilesLenght: state.status == AlbumDetailStatus.loaded ? state.files.length : 0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return BlocConsumer<AlbumDetailCubit, AlbumDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.status == AlbumDetailStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == AlbumDetailStatus.loaded) {
          return FileListGrid(
            files: state.files,
            isSelectionMode: state.isSelectionMode,
            selectedFileIds: state.selectedFileIds,
            onFileTap: _handleFileTap,
            onFileLongPress: _handleFileLongPress,
            scrollController: _scrollController,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    return BlocBuilder<AlbumDetailCubit, AlbumDetailState>(
      buildWhen: (previous, current) {
        if (previous.status == AlbumDetailStatus.loaded && current.status == AlbumDetailStatus.loaded) {
          return previous.isSelectionMode != current.isSelectionMode;
        }
        return previous.status != current.status;
      },
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 100),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: (state.status == AlbumDetailStatus.loaded && state.isSelectionMode)
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  key: const ValueKey('add_files_button'),
                  backgroundColor: const Color(0xFF9447FF),
                  shape: const CircleBorder(),
                  foregroundColor: Colors.white,
                  onPressed: () => _handleAddFiles(),
                  child: _isAddingFiles
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.add),
                ),
        );
      },
    );
  }

  // ==================== EVENT HANDLERS ====================

  void _handleFileTap(GuardFileModel file) {
    if (_cubit.state.status == AlbumDetailStatus.loaded) {
      final state = _cubit.state;
      if (state.isSelectionMode) {
        _cubit.toggleSelectionFile(file.id);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaViewerScreen(
              images: state.files,
              initialIndex: state.files.indexWhere((f) => f.id == file.id),
              albumId: widget.albumId,
              onMediaEdited: (editedFile) {
                _cubit.updateEditedImage(editedFile);
              },
            ),
          ),
        );
      }
    }
  }

  void _handleFileLongPress(GuardFileModel file) {
    if (_cubit.state.status == AlbumDetailStatus.loaded) {
      final state = _cubit.state;
      if (!state.isSelectionMode) {
        _cubit.toggleSelectionFile(file.id);
      }
    }
  }

  void _handleAddFiles() async {
    await Navigator.pushNamed(
      context,
      RoutesNamed.mediaImport,
      arguments: {
        'onAdd': (List<String> assetIds) async {
          setState(() {
            _isAddingFiles = true;
          });
          await _cubit.addFiles(assetIds);
          if (mounted) {
            deleteLocalFiles(assetIds);
            setState(() {
              _isAddingFiles = false;
            });
          }
        },
      },
    );
    _cubit.loadFiles();
  }
}
