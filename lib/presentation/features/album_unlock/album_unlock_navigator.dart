import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/global_keys.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/album_unlock_screen.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class AlbumUnlockNavigatorParams {
  final String title;
  final String? albumName;
  final int? albumId;
  final AlbumUnlockMode mode;
  final VoidCallback? onCancel;
  final Function(bool)? onComplete;
  final Function(String)? onCreated;

  const AlbumUnlockNavigatorParams({
    required this.title,
    this.albumName,
    this.albumId,
    required this.mode,
    this.onCancel,
    this.onComplete,
    this.onCreated,
  });
}

class AlbumUnlockNavigator {
  static final context = GlobalKeys.navigatorKey.currentContext;

  static void navigateToAlbumUnlock(AlbumUnlockNavigatorParams params) {
    if (context == null) return;

    Navigator.pushNamed(
      context!,
      RoutesNamed.albumUnlock,
      arguments: {
        'title': params.title,
        'albumName': params.albumName,
        'albumId': params.albumId,
        'mode': params.mode,
        'onCancel': params.onCancel,
        'onComplete': params.onComplete,
        'onCreated': params.onCreated,
      },
    );
  }
}
