import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/extensions/color_extension.dart';
import 'package:media_guard_v2/presentation/features/import_media/cubit/import_media_cubit.dart';
import 'package:media_guard_v2/presentation/features/import_media/view/image_item_widget.dart';
import 'package:photo_manager/photo_manager.dart';

class ImportMediaScreen extends StatefulWidget {
  final Function(List<String> assetIds)? onAdd;

  const ImportMediaScreen({
    super.key,
    this.onAdd,
  });

  @override
  State<ImportMediaScreen> createState() => _ImportMediaScreenState();
}

class _ImportMediaScreenState extends State<ImportMediaScreen> {
  final ScrollController _scrollController = ScrollController();
  final Set<String> _selectedImages = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<ImportMediaCubit>().initializeAlbums();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 500) {
      context.read<ImportMediaCubit>().loadMoreAssets();
    }
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedImages.clear();
      }
    });
  }

  void _toggleImageSelection(String imageId) {
    setState(() {
      if (_selectedImages.contains(imageId)) {
        _selectedImages.remove(imageId);
        if (_selectedImages.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedImages.add(imageId);
      }
    });
  }

  void _selectAllImages(ImportMediaState state) {
    setState(() {
      if (_selectedImages.length == state.entities.length) {
        // If all are selected, deselect all and exit selection mode
        _selectedImages.clear();
        _isSelectionMode = false;
      } else {
        // Select all images
        _selectedImages.clear();
        for (var entity in state.entities) {
          _selectedImages.add(entity.id);
        }
      }
    });
  }

  void _handleImageTap(String imageId) {
    if (!_isSelectionMode) {
      setState(() {
        _isSelectionMode = true;
        _selectedImages.add(imageId);
      });
    } else {
      _toggleImageSelection(imageId);
    }
  }

  void _showAlbumSelector(ImportMediaState state) {
    final cubit = context.read<ImportMediaCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext modalContext) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(
            maxHeight: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Title
              Row(
                children: [
                  const Icon(Icons.photo_album, color: Color(0xFF9447FF), size: 24),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.selectAlbum,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Album list
              Expanded(
                child: ListView.builder(
                  itemCount: state.albums.length,
                  itemBuilder: (context, index) {
                    final album = state.albums[index];
                    final isSelected = state.selectedAlbumIndex == index;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF9447FF).withOpacityValue(0.1) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? Border.all(color: const Color(0xFF9447FF), width: 2) : Border.all(color: Colors.grey[200]!, width: 1),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF9447FF) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.photo_album,
                            color: isSelected ? Colors.white : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                        title: Text(
                          album.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isSelected ? const Color(0xFF9447FF) : Colors.black87,
                          ),
                        ),
                        trailing: isSelected
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9447FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, color: Colors.white, size: 16),
                              )
                            : null,
                        onTap: () {
                          Navigator.pop(modalContext);
                          cubit.switchAlbum(index);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPermissionDialog() {
    final cubit = context.read<ImportMediaCubit>();

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.warning, color: Colors.red[600], size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.permissionRequired,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          content: Text(
            AppStrings.permissionRequiredMessage,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                AppStrings.cancel,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                cubit.initializeAlbums();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9447FF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(AppStrings.retry),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridView(ImportMediaState state) {
    return GridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.only(
        bottom: _isSelectionMode ? 120.0 : 12,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 1.0,
        mainAxisSpacing: 1.0,
      ),
      itemCount: state.entities.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == state.entities.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9447FF)),
              ),
            ),
          );
        }

        final AssetEntity entity = state.entities[index];
        return Stack(
          children: [
            ImageItemWidget(
              key: ValueKey<String>(entity.id),
              entity: entity,
              option: const ThumbnailOption(size: ThumbnailSize.square(300)),
              onTap: () => _handleImageTap(entity.id),
            ),
            if (_isSelectionMode)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _selectedImages.contains(entity.id) ? const Color(0xFF9447FF) : Colors.white.withOpacityValue(0.8),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedImages.contains(entity.id) ? const Color(0xFF9447FF) : Colors.grey[400]!,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacityValue(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _selectedImages.contains(entity.id)
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBody(ImportMediaState state) {
    if (state.isInitializing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacityValue(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9447FF)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.loadingAlbums,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (state.hasError) {
      return Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacityValue(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                state.errorMessage ?? AppStrings.anErrorOccurred,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  if (state.errorMessage?.contains('Permission') == true) {
                    _showPermissionDialog();
                  } else {
                    context.read<ImportMediaCubit>().initializeAlbums();
                  }
                },
                icon: const Icon(Icons.refresh),
                label: Text(AppStrings.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9447FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildGridView(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImportMediaCubit, ImportMediaState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: _isSelectionMode
                ? Text(
                    '${_selectedImages.length} ${AppStrings.selected}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  )
                : Text(
                    state.currentAlbum?.name ?? AppStrings.importMedia,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Colors.black87,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (_isSelectionMode) ...[
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.select_all,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                  onPressed: () => _selectAllImages(state),
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF9447FF),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    if (_selectedImages.isNotEmpty) {
                      widget.onAdd?.call(_selectedImages.toList());
                      Navigator.pop(context);
                    }
                  },
                ),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black87,
                    ),
                  ),
                  onPressed: _toggleSelectionMode,
                ),
              ] else ...[
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton.icon(
                    onPressed: () => _showAlbumSelector(state),
                    icon: const Icon(Icons.photo_album, size: 18),
                    label: Text(
                      state.currentAlbum?.name ?? AppStrings.selectAlbum,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9447FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }
}
