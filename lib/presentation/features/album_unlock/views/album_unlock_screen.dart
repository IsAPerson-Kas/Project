import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:media_guard_v2/core/constaints/app_strings.dart';
import 'package:media_guard_v2/data/datasources/app_preferences.dart';
import 'package:media_guard_v2/domain/repositories/album_repository.dart';
import 'package:media_guard_v2/domain/repositories/file_repository.dart';
import 'package:media_guard_v2/main.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/cubit/album_unlock_cubit.dart';
import 'package:media_guard_v2/presentation/features/album_unlock/views/pin_pad.dart';

enum AlbumUnlockMode {
  unlock, // Mở khóa - cần validate
  create, // Tạo mật khẩu - không cần validate
}

class AlbumUnlockScreen extends StatefulWidget {
  final String title;
  final String? albumName;
  final int? albumId;
  final AlbumUnlockMode mode;
  final VoidCallback? onCancel;
  final Function(bool)? onComplete;
  final Function(String)? onCreated;

  const AlbumUnlockScreen({
    super.key,
    required this.title,
    this.albumName,
    this.albumId,
    required this.mode,
    this.onCancel,
    this.onComplete,
    this.onCreated,
  });

  @override
  State<AlbumUnlockScreen> createState() => _AlbumUnlockScreenState();
}

class _AlbumUnlockScreenState extends State<AlbumUnlockScreen> {
  final AlbumUnlockCubit _cubit = AlbumUnlockCubit(
    albumRepository: getIt<AlbumRepository>(),
    fileRepository: getIt<FileRepository>(),
  );

  final LocalAuthentication _localAuth = LocalAuthentication();

  String _enteredPassword = '';
  String _firstPassword = ''; // For create mode - first password entry
  bool _isConfirmingPassword = false; // For create mode - second password entry

  // Biometric authentication state
  bool _isBiometricSupported = false;
  bool _isBiometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    // Only start camera in unlock mode
    if (widget.mode == AlbumUnlockMode.unlock) {
      _cubit.startCamera();
      _checkBiometricSupport();
    }
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      final bool isAvailable = await _localAuth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics = await _localAuth.getAvailableBiometrics();

      if (mounted) {
        setState(() {
          _isBiometricSupported = isDeviceSupported && isAvailable;
          _isBiometricAvailable = availableBiometrics.isNotEmpty;
          _availableBiometrics = availableBiometrics;
        });
      }

      log('Device supported: $isDeviceSupported');
      log('Can check biometrics: $isAvailable');
      log('Available biometrics: $availableBiometrics');
      log('Biometric available: ${_isBiometricSupported && _isBiometricAvailable}');
    } catch (e) {
      log('Error checking biometric support: $e');
      if (mounted) {
        setState(() {
          _isBiometricSupported = false;
          _isBiometricAvailable = false;
          _availableBiometrics = [];
        });
      }
    }
  }

  @override
  void dispose() {
    _cubit.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == AlbumUnlockMode.unlock) {
      return BlocProvider.value(
        value: _cubit,
        child: BlocListener<AlbumUnlockCubit, AlbumUnlockState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
              _cubit.clearError();
            }
          },
          child: _buildContent(),
        ),
      );
    } else {
      return _buildContent();
    }
  }

  Widget _buildContent() {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16, left: 24, right: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              widget.mode == AlbumUnlockMode.unlock ? widget.title : (_isConfirmingPassword ? AppStrings.confirmPassword : widget.title),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.mode == AlbumUnlockMode.unlock ? AppStrings.enterPasswordToAccess : (_isConfirmingPassword ? AppStrings.confirmPasswordMessage : AppStrings.enterPasswordToCreate),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (index) {
                return Container(
                  width: 16,
                  height: 16,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _enteredPassword.length ? Color(0xFF9447FF) : Colors.grey[400],
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            if (widget.mode == AlbumUnlockMode.unlock)
              BlocBuilder<AlbumUnlockCubit, AlbumUnlockState>(
                builder: (context, state) {
                  if (state.isCameraActive) {
                    return Text(
                      AppStrings.frontCameraActive,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[600],
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            const SizedBox(height: 16),
            Expanded(
              child: PinPad(
                showBiometric: widget.mode == AlbumUnlockMode.unlock && _isBiometricSupported && _isBiometricAvailable,
                onPressed: (value) {
                  if (_enteredPassword.length < 6) {
                    setState(() {
                      _enteredPassword += value;
                    });

                    // Auto-submit when 6 digits are entered
                    if (_enteredPassword.length == 6) {
                      _handlePasswordValidation();
                    }
                  }
                },
                onDelete: () {
                  if (_enteredPassword.isNotEmpty) {
                    setState(() {
                      _enteredPassword = _enteredPassword.substring(0, _enteredPassword.length - 1);
                    });
                  } else if (widget.mode == AlbumUnlockMode.create && _isConfirmingPassword) {
                    setState(() {
                      _enteredPassword = '';
                      _firstPassword = '';
                      _isConfirmingPassword = false;
                    });
                  }
                },
                onBiometric: () {
                  if (widget.mode == AlbumUnlockMode.unlock) {
                    _handleBiometricAuth();
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            if (widget.mode == AlbumUnlockMode.unlock && _isBiometricSupported && _isBiometricAvailable)
              Text(
                AppStrings.useFingerprintToUnlock,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePasswordValidation() async {
    if (_enteredPassword.length != 6) return;

    try {
      if (widget.mode == AlbumUnlockMode.unlock) {
        // UNLOCK MODE: Validate password
        bool isValid = false;

        if (widget.albumId != null) {
          isValid = await _cubit.validateAlbumPassword(_enteredPassword, widget.albumId!, isUnlockMode: true);
        } else if (widget.onComplete != null) {
          // For operations like delete and remove, we don't need to validate against album ID
          // The calling method will handle the validation
          isValid = true;
        }

        if (isValid) {
          // Capture image on successful attempt
          final imagePath = await _cubit.captureImage();
          if (imagePath != null) {
            await _cubit.saveFailedAttemptImage(imagePath);
          }

          if (mounted) {
            Navigator.pop(context);
            widget.onComplete?.call(true);
          }
        } else {
          // Capture image on failed attempt
          final imagePath = await _cubit.captureImage();
          if (imagePath != null) {
            await _cubit.saveFailedAttemptImage(imagePath);
          }

          if (mounted) {
            setState(() {
              _enteredPassword = '';
            });

            // Get current failed attempts to show in snack bar
            final failedAttempts = await AppPreferences.getFailedAttempts();
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${AppStrings.incorrectPassword} ($failedAttempts/5)')),
              );
            }
          }
        }
      } else {
        // CREATE MODE: Two-step password creation
        if (!_isConfirmingPassword) {
          // First password entry
          setState(() {
            _firstPassword = _enteredPassword;
            _enteredPassword = '';
            _isConfirmingPassword = true;
          });
        } else {
          // Second password entry - confirm
          if (_enteredPassword == _firstPassword) {
            // Passwords match - create password
            if (mounted) {
              Navigator.pop(context);
              widget.onCreated?.call(_enteredPassword);
            }
          } else {
            // Passwords don't match - reset to first entry
            if (mounted) {
              setState(() {
                _enteredPassword = '';
                _firstPassword = '';
                _isConfirmingPassword = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppStrings.passwordMismatch)),
              );
            }
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    } finally {
      if (mounted) {
        // Validation completed
      }
    }
  }

  Future<void> _handleBiometricAuth() async {
    if (!_isBiometricSupported || !_isBiometricAvailable) {
      log('Biometric authentication not available');
      return;
    }

    try {
      log('Starting biometric authentication');
      log('Available biometrics: $_availableBiometrics');

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: AppStrings.authenticateDeviceOwnership,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      if (mounted) {
        if (didAuthenticate) {
          log('Biometric authentication successful');

          // Capture image on successful authentication
          final imagePath = await _cubit.captureImage();
          if (imagePath != null) {
            await _cubit.saveFailedAttemptImage(imagePath);
          }

          // Navigate back with success - treat biometric success as valid password
          if (mounted) {
            Navigator.pop(context);
            widget.onComplete?.call(true);
          }
        } else {
          log('Biometric authentication failed');

          // Capture image on failed authentication
          final imagePath = await _cubit.captureImage();
          if (imagePath != null) {
            await _cubit.saveFailedAttemptImage(imagePath);
          }

          // Show error message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppStrings.biometricAuthFailed)),
            );
          }
        }
      }
    } catch (e) {
      log('Biometric authentication error: $e');

      // Capture image on error
      final imagePath = await _cubit.captureImage();
      if (imagePath != null) {
        await _cubit.saveFailedAttemptImage(imagePath);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${AppStrings.biometricAuthError}: $e')),
        );
      }
    }
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.black,
          size: 28,
        ),
        onPressed: () {
          Navigator.pop(context);
          widget.onCancel?.call();
        },
      ),
    );
  }
}
