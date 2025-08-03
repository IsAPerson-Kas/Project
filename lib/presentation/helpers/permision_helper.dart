import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/constaints/global_keys.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/common_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/confirm_dialog.dart';
import 'package:media_guard_v2/presentation/helpers/dialog/info_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  PermissionHelper._();

  /// kiểm tra quyền đọc thư viện ảnh
  static Future<bool> checkPhotoPermission() async {
    final permission = await _permissionNeedToAccessPhoto();
    final status = await permission.status;
    return status.isGranted;
  }

  /// kiểm tra quyền camera
  static Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// kiểm tra cả quyền photo và camera
  static Future<bool> checkPhotoAndCameraPermission() async {
    final photoPermission = await _permissionNeedToAccessPhoto();
    final photoStatus = await photoPermission.status;
    final cameraStatus = await Permission.camera.status;

    return photoStatus.isGranted && cameraStatus.isGranted;
  }

  /// yêu cầu quyền photo
  static Future<void> requestPhotoPermission({
    required VoidCallback onGranted,
  }) async {
    final permission = await _permissionNeedToAccessPhoto();
    await _requestPermission(
      permission: permission,
      onGranted: onGranted,
    );
  }

  /// yêu cầu cả quyền photo và camera
  static Future<void> requestPhotoAndCameraPermission({
    required VoidCallback onGranted,
  }) async {
    final photoPermission = await _permissionNeedToAccessPhoto();
    final photoStatus = await photoPermission.status;
    final cameraStatus = await Permission.camera.status;

    // Nếu cả hai quyền đã được cấp
    if (photoStatus.isGranted && cameraStatus.isGranted) {
      onGranted();
      return;
    }

    // Yêu cầu quyền photo trước
    if (!photoStatus.isGranted) {
      await _requestPermission(
        permission: photoPermission,
        onGranted: () async {
          // Sau khi có quyền photo, yêu cầu quyền camera
          if (cameraStatus.isGranted) {
            onGranted();
          } else {
            await _requestPermission(
              permission: Permission.camera,
              onGranted: onGranted,
            );
          }
        },
      );
    } else {
      // Nếu đã có quyền photo, chỉ yêu cầu quyền camera
      await _requestPermission(
        permission: Permission.camera,
        onGranted: onGranted,
      );
    }
  }

  /// yêu cầu quyền camera
  static Future<void> requestCameraPermission({
    required VoidCallback onGranted,
  }) async {
    await _requestPermission(
      permission: Permission.camera,
      onGranted: onGranted,
    );
  }

  static Future<Permission> _permissionNeedToAccessPhoto() async {
    if (Platform.isIOS) {
      return Permission.photos;
    } else if (Platform.isAndroid) {
      final androidInfor = await DeviceInfoPlugin().androidInfo;
      final androidVersion = androidInfor.version.sdkInt;
      return androidVersion >= 33 ? Permission.photos : Permission.storage;
    }
    return Permission.photos;
  }

  /// Hàm kiểm tra một quyền cụ thể và xử lý kết quả
  static Future<void> _requestPermission({
    required Permission permission,
    required VoidCallback onGranted,
  }) async {
    final status = await permission.status;

    switch (status) {
      case PermissionStatus.granted:
        onGranted();
        break;

      case PermissionStatus.denied:
        final tmpStatus = await permission.request();
        if (tmpStatus == PermissionStatus.granted) {
          onGranted();
        }
        break;
      case PermissionStatus.permanentlyDenied:
        _showGoToAppSettingsDialog(permission);
        break;
      case PermissionStatus.restricted:
        _showRestrictedDialog(permission);
        break;
      default:
        break;
    }
  }

  /// Hiển thị dialog khi quyền bị hệ thống hạn chế (restricted)
  static void _showRestrictedDialog(Permission permission) {
    final name = _getPermissionName(permission);
    CommonDialog.showCustomDialog(
      child: InfoDialog(
        title: '$name ${AppStrings.accessRestricted}',
        message: '${AppStrings.appCannotAccess} $name ${AppStrings.becausePermissionRestricted}',
        onAcknowledge: () {},
      ),
    );
  }

  /// Hiển thị dialog mở app settings khi quyền bị từ chối vĩnh viễn
  static void _showGoToAppSettingsDialog(Permission permission) {
    final name = _getPermissionName(permission);
    final navigatorContext = GlobalKeys.navigatorKey.currentContext!;
    CommonDialog.showCustomDialog(
      child: ConfirmDialog(
        title: '$name ${AppStrings.permissionRequired}',
        message: '$name ${AppStrings.permissionPermanentlyDenied}',
        cancelText: AppStrings.cancel,
        confirmText: AppStrings.openSettings,
        onCancel: () => Navigator.of(navigatorContext).pop(),
        onConfirm: () {
          openAppSettings();
          Navigator.of(navigatorContext).pop();
        },
      ),
    );
  }

  /// Trả về tên quyền hiển thị cho người dùng
  static String _getPermissionName(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return AppStrings.camera;
      case Permission.photos:
        return AppStrings.photos;
      case Permission.storage:
        return AppStrings.photos;
      default:
        return AppStrings.thisPermission;
    }
  }
}

extension CameraAndPhotoPermissionExtension on Permission {}
