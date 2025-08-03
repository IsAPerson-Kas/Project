import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/presentation/features/album_detail/views/album_detail_screen.dart';
import 'package:media_guard_v2/presentation/features/album_list/views/album_list_screen.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:media_guard_v2/presentation/features/import_media/cubit/import_media_cubit.dart';
import 'package:media_guard_v2/presentation/features/import_media/import_media_screen.dart';
import 'package:media_guard_v2/presentation/features/initial/initial_screen.dart';
import 'package:media_guard_v2/presentation/features/onboarding/onboarding_screen.dart';
import 'package:media_guard_v2/presentation/features/settings/settings_screen.dart';
import 'package:media_guard_v2/presentation/features/unlock_failed/unlock_failed_cubit.dart';
import 'package:media_guard_v2/presentation/features/unlock_failed/unlock_failed_screen.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class RoutesGenerate {
  RoutesGenerate._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesNamed.initial:
        return _buildRoute(InitialScreen(), settings: settings);
      case RoutesNamed.onboarding:
        return _buildRoute(OnboardingScreen(), settings: settings);
      case RoutesNamed.mediaImport:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          BlocProvider(
            create: (context) => ImportMediaCubit(),
            child: ImportMediaScreen(
              onAdd: args?['onAdd'] as Function(List<String>)?,
            ),
          ),
          settings: settings,
        );
      case RoutesNamed.unlockFailed:
        return _buildRoute(
          BlocProvider(
            create: (context) => UnlockFailedCubit(),
            child: const UnlockFailedScreen(),
          ),
          settings: settings,
        );
      case RoutesNamed.settings:
        return _buildRoute(
          const SettingsScreen(),
          settings: settings,
        );
      case RoutesNamed.album:
        return _buildRoute(const AlbumListScreen(), settings: settings);
      case RoutesNamed.albumDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return _buildRoute(
          AlbumDetailScreen(albumName: args['name'] as String, albumId: args['id'] as int),
          settings: settings,
        );
      case RoutesNamed.albumUnlock:
        final args = settings.arguments as Map<String, dynamic>?;
        return _buildRoute(
          AlbumUnlockScreen(
            title: args?['title'] as String? ?? AppStrings.unlockAlbum,
            albumName: args?['albumName'] as String?,
            albumId: args?['albumId'] as int?,
            mode: args?['mode'] as AlbumUnlockMode? ?? AlbumUnlockMode.unlock,
            onCancel: args?['onCancel'] as VoidCallback?,
            onComplete: args?['onComplete'] as Function(bool)?,
            onCreated: args?['onCreated'] as Function(String)?,
          ),
          settings: settings,
        );
      default:
        return _buildRoute(const _ErrorScreen(), settings: settings);
    }
  }

  static MaterialPageRoute _buildRoute(Widget child, {RouteSettings? settings}) {
    return MaterialPageRoute(settings: settings, builder: (BuildContext context) => child);
  }

  // static Route<dynamic> _buildRouteWithTransition(Widget child, {RouteSettings settings}) {
  //   return PageRouteBuilder(
  //     settings: settings,
  //     pageBuilder: (context, animation, secondaryAnimation) => child,
  //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //       const begin = Offset(0.0, 1.0);
  //       const end = Offset.zero;
  //       const curve = Curves.easeInOut;

  //       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  //       var offsetAnimation = animation.drive(tween);

  //       return SlideTransition(position: offsetAnimation, child: child);
  //     },
  //   );
  // }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.error)),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.error, size: 100), Text(AppStrings.error404)]),
      ),
    );
  }
}
