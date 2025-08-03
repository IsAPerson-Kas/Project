import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/constaints/global_keys.dart';
import 'package:media_guard_v2/data/datasources/local_database/app_database.dart';
import 'package:media_guard_v2/data/datasources/local_database/daos/album_dao.dart';
import 'package:media_guard_v2/data/datasources/local_database/daos/file_dao.dart';
import 'package:media_guard_v2/data/repositories_impl/album_repository_impl.dart';
import 'package:media_guard_v2/data/repositories_impl/file_repository_impl.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/cubit/album_unlock_cubit.dart';
import 'package:media_guard_v2/router/routes_generate.dart';
import 'package:media_guard_v2/router/routes_named.dart';
import 'package:photo_manager/photo_manager.dart';

final getIt = GetIt.instance;

Future<void> _createDefaultAlbum() async {
  final albumRepos = getIt<AlbumRepository>();
  final defaultAlbum = await albumRepos.getAlbumById(0);

  if (defaultAlbum == null) {
    await albumRepos.addAlbum(name: AppStrings.failedPasswordAttemptsAlbum, id: 0);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PhotoManager.clearFileCache();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final appDatabase = AppDatabase();
  final albumDao = AlbumDao(appDatabase);
  final fileDao = FileDao(appDatabase);
  final albumRepository = AlbumRepositoryImpl(albumDao);
  final fileRepository = FileRepositoryImpl(fileDao);

  getIt.registerSingleton<AlbumRepository>(albumRepository);
  getIt.registerSingleton<FileRepository>(fileRepository);

  getIt.registerSingleton<AlbumUnlockCubit>(AlbumUnlockCubit(albumRepository: albumRepository, fileRepository: fileRepository));

  await _createDefaultAlbum();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSystemUIWrapper(
      child: MaterialApp(
        navigatorKey: GlobalKeys.navigatorKey,
        title: AppStrings.appName,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
          ),
        ),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        initialRoute: RoutesNamed.initial,
        onGenerateRoute: RoutesGenerate.onGenerateRoute,
      ),
    );
  }
}

class CustomSystemUIWrapper extends StatelessWidget {
  final Widget child;

  const CustomSystemUIWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black45,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: child,
    );
  }
}
