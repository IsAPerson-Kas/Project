import 'package:flutter/material.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/core/constaints/assets_path.dart';
import 'package:media_guard_v2/presentation/helpers/permision_helper.dart';
import 'package:media_guard_v2/presentation/widgets/guard_text_button.dart';
import 'package:media_guard_v2/router/routes_named.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    // Đăng ký observer để lắng nghe lifecycle của app
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Hủy đăng ký observer khi widget bị dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Khi app resume (quay lại từ background)
    if (state == AppLifecycleState.resumed) {
      _checkPermissionAndNavigate();
    }
  }

  Future<void> _checkPermissionAndNavigate() async {
    // Kiểm tra cả quyền photo và camera hiện tại
    final hasPermission = await PermissionHelper.checkPhotoAndCameraPermission();

    if (hasPermission && mounted) {
      // Nếu đã có quyền, navigate đến GuardAlbumScreen
      Navigator.pushReplacementNamed(context, RoutesNamed.album);
    }
  }

  Future<void> _requestMediaPermissions() async {
    PermissionHelper.requestPhotoAndCameraPermission(
      onGranted: () {
        _checkPermissionAndNavigate();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: AspectRatio(
                aspectRatio: 351 / 319.41,
                child: Image.asset(
                  AssetsPath.permissionDecorImage,
                  fit: BoxFit.contain,
                  width: double.infinity,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                AppStrings.appNeedsPermissions,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GuardTextButton(
                label: AppStrings.grantPermission,
                height: 45,
                onTap: _requestMediaPermissions,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
