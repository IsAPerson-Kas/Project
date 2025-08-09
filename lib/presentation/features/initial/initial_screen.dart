import 'package:flutter/material.dart';
import 'package:media_guard_v2/data/datasources/app_preferences.dart';
import 'package:media_guard_v2/presentation/helpers/permision_helper.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Check if app is locked first
      final isAppLocked = await AppPreferences.isAppLocked();
      if (isAppLocked) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesNamed.appLock);
        }
        return;
      }

      final isHaveGalleryPermission = await PermissionHelper.checkPhotoPermission();
      if (isHaveGalleryPermission) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesNamed.album);
        }
      } else {
        if (mounted) {
          Navigator.pushReplacementNamed(context, RoutesNamed.onboarding);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
