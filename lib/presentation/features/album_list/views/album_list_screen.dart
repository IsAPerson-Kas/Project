import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/constaints/assets_path.dart';
import 'package:media_guard_v2/domain/models/guard_album_model.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:media_guard_v2/presentation/features/album_list/album_list_cubit.dart';
import 'package:media_guard_v2/presentation/features/album_list/views/album_list_grid.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/album_unlock_navigator.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/text_field_dialog.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({super.key});

  @override
  State<AlbumListScreen> createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  late final AlbumListCubit _cubit = AlbumListCubit(
    albumRepository: getIt<AlbumRepository>(),
    fileRepository: getIt<FileRepository>(),
  )..loadAlbums();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
      },
      child: Scaffold(
        extendBody: true,
        appBar: _buildAppBar(),
        body: BlocProvider(
          create: (context) => _cubit,
          child: _buildBody(context),
        ),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.appName),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.black),
        onPressed: () {
          Navigator.pushNamed(context, RoutesNamed.settings);
        },
      ),
      actions: [
        // SizedBox(
        //   width: 48.0,
        //   height: 48.0,
        //   child: GestureDetector(
        //     onTap: _showAddAlbumDialog,
        //     child: Align(
        //       alignment: Alignment.center,
        //       child: SvgPicture.asset(
        //         AssetsPath.icAddAlbum,
        //         width: 24.0,
        //         height: 24.0,
        //         colorFilter: ColorFilter.mode(
        //           Colors.black,
        //           BlendMode.srcIn,
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<AlbumListCubit, AlbumListState>(
      builder: (context, state) {
        switch (state) {
          case AlbumListLoading():
            return const Center(child: CircularProgressIndicator());
          case AlbumListLoaded(albums: List<GuardAlbumModel> albums):
            return AlbumListGrid(
              albums: albums,
              onAlbumTap: _handleAlbumTap,
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }

  void _showAddAlbumDialog() {
    final TextEditingController controller = TextEditingController();
    CommonDialog.showCustomDialog(
      child: TextFieldDialog(
        title: AppStrings.addNewAlbum,
        activeButtonText: AppStrings.add,
        controller: controller,
        hintText: AppStrings.enterAlbumName,
        onCancel: () => Navigator.pop(context),
        onActive: (text) {
          _cubit.addAlbum(text);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleAlbumTap(GuardAlbumModel album) {
    if (album.password != null) {
      _showPasswordDialog(album.name, album.id);
    } else {
      Navigator.pushNamed(
        context,
        RoutesNamed.albumDetail,
        arguments: {
          'name': album.name,
          'id': album.id,
        },
      );
    }
  }

  void _showPasswordDialog(String albumName, int albumId) {
    AlbumUnlockNavigator.navigateToAlbumUnlock(
      AlbumUnlockNavigatorParams(
        title: AppStrings.unlockAlbum,
        albumName: albumName,
        albumId: albumId,
        mode: AlbumUnlockMode.unlock,
        onComplete: (bool success) {
          if (success) {
            // Authentication successful, proceed to album detail
            Navigator.pushNamed(
              context,
              RoutesNamed.albumDetail,
              arguments: {
                'name': albumName,
                'id': albumId,
              },
            );
          }
        },
        onCancel: () {
          // Handle cancel if needed
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      key: const ValueKey('add_files_button'),
      backgroundColor: const Color(0xFF9447FF),
      shape: const CircleBorder(),
      foregroundColor: Colors.white,
      onPressed: () => _showAddAlbumDialog(),
      child: const Icon(Icons.add),
    );
  }
}
