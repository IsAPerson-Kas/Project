enum Language { english, vietnamese }

class AppStrings {
  AppStrings._();

  static const int android11SDKINT = 30;
  static const String sharedMediaIdentifier = '-guard-shared-media://';

  // Language-specific strings
  static const Map<Language, Map<String, String>> _strings = {
    Language.english: {
      'appName': 'Photo Guard',
      'album': 'Album',
      'addNewAlbum': 'Add New Album',
      'enterAlbumName': 'Enter album name',
      'add': 'Add',
      'enterPassword': 'Enter Password',
      'enterAlbumPassword': 'Enter album password',
      'enter': 'Enter',
      'incorrectPassword': 'Incorrect password',
      'viewFailedAttempts': 'View Failed Attempts',
      'failedPassword': 'Failed Password',
      'selected': 'selected',
      'warningFrontCameraActive': 'Warning: Front camera is active',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'language': 'Language',
      'noFailedAttemptsRecorded': 'No failed attempts recorded',
      'deleteSelectedFiles': 'Delete Selected Files',
      'deleteSelectedFilesConfirmation': 'Are you sure you want to delete the selected files?',
      'delete': 'Delete',
      'authentication': 'Authentication',
      'authenticateDeviceOwnership': 'Please authenticate device ownership to continue.',
      'authenticate': 'Authenticate',
      'selectAlbum': 'Select Album',
      'permissionRequired': 'Permission Required',
      'permissionRequiredMessage': 'This app needs access to your photos to display them. Please grant permission in your device settings.',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'retry': 'Retry',
      'loadingAlbums': 'Loading albums...',
      'anErrorOccurred': 'An error occurred',
      'importMedia': 'Import Media',
      'onboarding': 'Welcome',
      'appNeedsPhotoPermission': 'The app needs photo library access to function',
      'appNeedsCameraPermission': 'The app needs camera access to monitor who is trying to access your data',
      'appNeedsPermissions': 'The app needs photo library and camera access to function and monitor who is trying to access your data',
      'grantPermission': 'Grant Permission',
      'renameAlbum': 'Rename Album',
      'rename': 'Rename',
      'enterNewAlbumName': 'Enter new album name',
      'deleteAlbum': 'Delete Album',
      'deleteAlbumConfirmation': 'Are you sure you want to delete this album? All files in this album will also be deleted.',
      'enterPasswordToDeleteAlbum': 'Enter password to delete album',
      'addPassword': 'Add Password',
      'enterPasswordToAdd': 'Enter password',
      'removePassword': 'Remove Password',
      'remove': 'Remove',
      'enterPasswordToRemove': 'Enter password to remove',
      'enterCurrentPassword': 'Enter current password',
      'failedToRemovePassword': 'Failed to remove password',
      'noFilesInAlbum': 'No files in this album',
      'select': 'Select',
      'unnamedAlbum': 'Unnamed Album',
      'failedToSetThumbnail': 'Failed to set thumbnail',
      'setAsThumbnail': 'Set as Thumbnail',
      'accessRestricted': 'Access Restricted',
      'appCannotAccess': 'The app cannot access',
      'becausePermissionRestricted': 'because the permission is restricted by the system.',
      'ok': 'OK',
      'permissionPermanentlyDenied': 'permission was permanently denied. Please go to settings to enable it.',
      'openSettings': 'Open Settings',
      'camera': 'Camera',
      'photos': 'Photos',
      'thisPermission': 'This',
      'error': 'Error',
      'error404': 'Error 404',
      'failedPasswordAttempts': 'Failed Password Attempts',
      'settings': 'Settings',
      'security': 'Security',
      'viewFailedAttemptsDescription': 'View photos captured during failed password attempts',
      'selectLanguage': 'Select your preferred language',
      'share': 'Share',
      'shareSelectedFiles': 'Share Selected Files',
      'shareSelectedFilesConfirmation': 'Share the selected files with other apps?',
      'unlockAlbum': 'Unlock Album',
      'enterPasswordToAccess': 'To access your locked albums, please enter the password.',
      'createPassword': 'Create Password',
      'enterPasswordToCreate': 'Please enter a 6-digit password for this album.',
      'confirmPassword': 'Confirm Password',
      'confirmPasswordMessage': 'Please re-enter the password to confirm.',
      'passwordMismatch': 'Passwords do not match, please try again.',
      'frontCameraActive': 'Front camera is active',
      'useFingerprintToUnlock': 'Press fingerprint to unlock with PIN or biometric',
      'biometricAuthError': 'Biometric authentication error',
      'biometricAuthSuccess': 'Biometric authentication successful',
      'biometricAuthFailed': 'Biometric authentication failed',
      'downloadSuccess': 'Files downloaded successfully',
      'downloadFailed': 'Failed to download files',
      // New translations
      'close': 'Close',
      'all': 'All',
      'download': 'Download',
      'downloadImages': 'Download Images',
      'downloadImagesConfirmation': 'Do you want to download the images?',
      'guestMode': 'Guest Mode',
      'editImage': 'Edit Image',
      'imageEdited': 'Image edited',
      'errorSavingEditedImage': 'Error saving edited image',
      'errorOpeningImageEditor': 'Error opening image editor',
      'thumbnailSet': 'Thumbnail set',
      'albumNotFound': 'Album not found',
      'failedToUpdateAlbum': 'Failed to update album',
      'greatPicture': 'Great picture',
      'checking': 'Checking...',
      'unknownAlbum': 'Unknown Album',
      'live': 'LIVE',
      'failedPasswordAttemptsAlbum': 'Failed Password Attempts',
      'permissionDenied': 'Permission denied. Please grant photo access permission.',
      'noAlbumsFound': 'No albums found on this device.',
      'failedToInitializeAlbums': 'Failed to initialize albums',
      'failedToLoadMoreAssets': 'Failed to load more assets',
      'failedToLoadAlbumAssets': 'Failed to load album assets',
      'idMustBePresent': 'ID must be present when updating',
      'appLocked': 'App Locked',
      'appLockedDueToIncorrectPassword': 'App is locked due to incorrect password',
      'timeRemaining': 'Time remaining:',
      'pleaseWaitForLockTime': 'Please wait for the lock time to expire to continue using the app',
    },
    Language.vietnamese: {
      'appName': 'Photo Guard',
      'album': 'Album',
      'addNewAlbum': 'Thêm Album Mới',
      'enterAlbumName': 'Nhập tên album',
      'add': 'Thêm',
      'enterPassword': 'Nhập Mật Khẩu',
      'enterAlbumPassword': 'Nhập mật khẩu album',
      'enter': 'Nhập',
      'incorrectPassword': 'Mật khẩu không đúng',
      'viewFailedAttempts': 'Xem Lần Thử Thất Bại',
      'failedPassword': 'Mật Khẩu Thất Bại',
      'selected': 'đã chọn',
      'warningFrontCameraActive': 'Cảnh báo: Camera trước đang hoạt động',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'language': 'Ngôn ngữ',
      'noFailedAttemptsRecorded': 'Không có lần thử thất bại nào được ghi lại',
      'deleteSelectedFiles': 'Xóa Các Tệp Đã Chọn',
      'deleteSelectedFilesConfirmation': 'Bạn có chắc chắn muốn xóa các tệp đã chọn?',
      'delete': 'Xóa',
      'authentication': 'Xác thực',
      'authenticateDeviceOwnership': 'Vui lòng xác thực quyền sở hữu thiết bị để tiếp tục.',
      'authenticate': 'Xác thực',
      'selectAlbum': 'Chọn Album',
      'permissionRequired': 'Yêu Cầu Quyền Truy Cập',
      'permissionRequiredMessage': 'Ứng dụng này cần quyền truy cập vào ảnh của bạn để hiển thị chúng. Vui lòng cấp quyền trong cài đặt thiết bị.',
      'cancel': 'Hủy',
      'confirm': 'Xác nhận',
      'retry': 'Thử Lại',
      'loadingAlbums': 'Đang tải album...',
      'anErrorOccurred': 'Đã xảy ra lỗi',
      'importMedia': 'Nhập Media',
      'onboarding': 'Chào mừng',
      'appNeedsPhotoPermission': 'Ứng dụng cần quyền truy cập thư viện để hoạt động',
      'appNeedsCameraPermission': 'Ứng dụng cần quyền truy cập camera để theo dõi ai đang cố truy cập vào dữ liệu của bạn',
      'appNeedsPermissions': 'Ứng dụng cần quyền truy cập thư viện ảnh và camera để hoạt động và theo dõi ai đang cố truy cập vào dữ liệu của bạn',
      'grantPermission': 'Cấp quyền',
      'renameAlbum': 'Đổi Tên Album',
      'rename': 'Đổi tên',
      'enterNewAlbumName': 'Nhập tên album mới',
      'deleteAlbum': 'Xóa Album',
      'deleteAlbumConfirmation': 'Bạn có chắc chắn muốn xóa album này? Tất cả tệp trong album này cũng sẽ bị xóa.',
      'enterPasswordToDeleteAlbum': 'Nhập mật khẩu để xóa album',
      'addPassword': 'Thêm Mật Khẩu',
      'enterPasswordToAdd': 'Nhập mật khẩu',
      'removePassword': 'Xóa Mật Khẩu',
      'remove': 'Xóa',
      'enterPasswordToRemove': 'Nhập mật khẩu để xóa',
      'enterCurrentPassword': 'Nhập mật khẩu hiện tại',
      'failedToRemovePassword': 'Không thể xóa mật khẩu',
      'noFilesInAlbum': 'Không có tệp nào trong album này',
      'select': 'Chọn',
      'unnamedAlbum': 'Album Không Tên',
      'failedToSetThumbnail': 'Không thể đặt làm album thumbnail',
      'setAsThumbnail': 'Đặt Làm album thumbnail',
      'accessRestricted': 'Truy Cập Bị Hạn Chế',
      'appCannotAccess': 'Ứng dụng không thể truy cập',
      'becausePermissionRestricted': 'vì quyền truy cập bị hệ thống hạn chế.',
      'ok': 'OK',
      'permissionPermanentlyDenied': 'quyền truy cập đã bị từ chối vĩnh viễn. Vui lòng vào cài đặt để bật nó.',
      'openSettings': 'Mở Cài Đặt',
      'camera': 'Camera',
      'photos': 'Ảnh',
      'thisPermission': 'Quyền này',
      'error': 'Lỗi',
      'error404': 'Lỗi 404',
      'failedPasswordAttempts': 'Lần Thử Mật Khẩu Thất Bại',
      'settings': 'Cài Đặt',
      'security': 'Bảo Mật',
      'viewFailedAttemptsDescription': 'Xem ảnh được chụp trong các lần thử mật khẩu thất bại',
      'selectLanguage': 'Chọn ngôn ngữ bạn muốn sử dụng',
      'share': 'Chia sẻ',
      'shareSelectedFiles': 'Chia Sẻ Các Tệp Đã Chọn',
      'shareSelectedFilesConfirmation': 'Chia sẻ các tệp đã chọn với ứng dụng khác?',
      'unlockAlbum': 'Mở Khóa Album',
      'enterPasswordToAccess': 'Để truy cập các album đã khóa của bạn, vui lòng nhập mật khẩu.',
      'createPassword': 'Tạo Mật Khẩu',
      'enterPasswordToCreate': 'Vui lòng nhập mật khẩu 6 chữ số cho album này.',
      'confirmPassword': 'Xác Nhận Mật Khẩu',
      'confirmPasswordMessage': 'Vui lòng nhập lại mật khẩu để xác nhận.',
      'passwordMismatch': 'Mật khẩu không khớp, vui lòng thử lại.',
      'frontCameraActive': 'Camera trước đang hoạt động',
      'useFingerprintToUnlock': 'Nhấn vào vân tay để mở khóa với PIN hoặc biểu tượng',
      'biometricAuthError': 'Lỗi xác thực sinh trắc học',
      'biometricAuthSuccess': 'Xác thực sinh trắc học thành công',
      'biometricAuthFailed': 'Xác thực sinh trắc học thất bại',
      'downloadSuccess': 'Tải file thành công',
      'downloadFailed': 'Tải file thất bại',
      // New translations
      'close': 'Đóng',
      'all': 'Tất cả',
      'download': 'Tải xuống',
      'downloadImages': 'Tải ảnh xuống',
      'downloadImagesConfirmation': 'Bạn có muốn tải ảnh xuống không?',
      'guestMode': 'Chế độ khách',
      'editImage': 'Chỉnh sửa ảnh',
      'imageEdited': 'Đã chỉnh sửa ảnh',
      'errorSavingEditedImage': 'Lỗi khi lưu ảnh đã chỉnh sửa',
      'errorOpeningImageEditor': 'Đã xảy ra lỗi khi mở trình chỉnh sửa ảnh',
      'thumbnailSet': 'Đã đặt làm ảnh album',
      'albumNotFound': 'Không tìm thấy album',
      'failedToUpdateAlbum': 'Không thể cập nhật album',
      'greatPicture': 'Ảnh đẹp',
      'checking': 'Đang kiểm tra...',
      'unknownAlbum': 'Album Không Xác Định',
      'live': 'LIVE',
      'failedPasswordAttemptsAlbum': 'Lần Thử Mật Khẩu Thất Bại',
      'permissionDenied': 'Quyền truy cập bị từ chối. Vui lòng cấp quyền truy cập ảnh.',
      'noAlbumsFound': 'Không tìm thấy album nào trên thiết bị này.',
      'failedToInitializeAlbums': 'Không thể khởi tạo album',
      'failedToLoadMoreAssets': 'Không thể tải thêm tài nguyên',
      'failedToLoadAlbumAssets': 'Không thể tải tài nguyên album',
      'idMustBePresent': 'ID phải có khi cập nhật',
      'appLocked': 'App Bị Khóa',
      'appLockedDueToIncorrectPassword': 'App đang bị khóa do nhập mật khẩu sai',
      'timeRemaining': 'Thời gian còn lại:',
      'pleaseWaitForLockTime': 'Vui lòng đợi hết thời gian khóa để tiếp tục sử dụng app',
    },
  };

  static Language _currentLanguage = Language.english;

  static Language get currentLanguage => _currentLanguage;

  static void setLanguage(Language language) {
    _currentLanguage = language;
  }

  static String get(String key) {
    return _strings[_currentLanguage]?[key] ?? _strings[Language.english]![key]!;
  }

  static String get appName => get('appName');
  static String get album => get('album');
  static String get addNewAlbum => get('addNewAlbum');
  static String get enterAlbumName => get('enterAlbumName');
  static String get add => get('add');
  static String get enterPassword => get('enterPassword');
  static String get enterAlbumPassword => get('enterAlbumPassword');
  static String get enter => get('enter');
  static String get incorrectPassword => get('incorrectPassword');
  static String get viewFailedAttempts => get('viewFailedAttempts');
  static String get failedPassword => get('failedPassword');
  static String get selected => get('selected');
  static String get warningFrontCameraActive => get('warningFrontCameraActive');
  static String get english => get('english');
  static String get vietnamese => get('vietnamese');
  static String get language => get('language');
  static String get noFailedAttemptsRecorded => get('noFailedAttemptsRecorded');
  static String get deleteSelectedFiles => get('deleteSelectedFiles');
  static String get deleteSelectedFilesConfirmation => get('deleteSelectedFilesConfirmation');
  static String get delete => get('delete');
  static String get authentication => get('authentication');
  static String get authenticateDeviceOwnership => get('authenticateDeviceOwnership');
  static String get authenticate => get('authenticate');
  static String get selectAlbum => get('selectAlbum');
  static String get permissionRequired => get('permissionRequired');
  static String get permissionRequiredMessage => get('permissionRequiredMessage');
  static String get cancel => get('cancel');
  static String get confirm => get('confirm');
  static String get retry => get('retry');
  static String get loadingAlbums => get('loadingAlbums');
  static String get anErrorOccurred => get('anErrorOccurred');
  static String get importMedia => get('importMedia');
  static String get onboarding => get('onboarding');
  static String get appNeedsPhotoPermission => get('appNeedsPhotoPermission');
  static String get appNeedsCameraPermission => get('appNeedsCameraPermission');
  static String get appNeedsPermissions => get('appNeedsPermissions');
  static String get grantPermission => get('grantPermission');
  static String get renameAlbum => get('renameAlbum');
  static String get rename => get('rename');
  static String get enterNewAlbumName => get('enterNewAlbumName');
  static String get deleteAlbum => get('deleteAlbum');
  static String get deleteAlbumConfirmation => get('deleteAlbumConfirmation');
  static String get enterPasswordToDeleteAlbum => get('enterPasswordToDeleteAlbum');
  static String get addPassword => get('addPassword');
  static String get enterPasswordToAdd => get('enterPasswordToAdd');
  static String get removePassword => get('removePassword');
  static String get remove => get('remove');
  static String get enterPasswordToRemove => get('enterPasswordToRemove');
  static String get enterCurrentPassword => get('enterCurrentPassword');
  static String get failedToRemovePassword => get('failedToRemovePassword');
  static String get noFilesInAlbum => get('noFilesInAlbum');
  static String get select => get('select');
  static String get unnamedAlbum => get('unnamedAlbum');
  static String get failedToSetThumbnail => get('failedToSetThumbnail');
  static String get setAsThumbnail => get('setAsThumbnail');
  static String get accessRestricted => get('accessRestricted');
  static String get appCannotAccess => get('appCannotAccess');
  static String get becausePermissionRestricted => get('becausePermissionRestricted');
  static String get ok => get('ok');
  static String get permissionPermanentlyDenied => get('permissionPermanentlyDenied');
  static String get openSettings => get('openSettings');
  static String get camera => get('camera');
  static String get photos => get('photos');
  static String get thisPermission => get('thisPermission');
  static String get error => get('error');
  static String get error404 => get('error404');
  static String get failedPasswordAttempts => get('failedPasswordAttempts');
  static String get settings => get('settings');
  static String get security => get('security');
  static String get viewFailedAttemptsDescription => get('viewFailedAttemptsDescription');
  static String get selectLanguage => get('selectLanguage');
  static String get share => get('share');
  static String get shareSelectedFiles => get('shareSelectedFiles');
  static String get shareSelectedFilesConfirmation => get('shareSelectedFilesConfirmation');
  static String get unlockAlbum => get('unlockAlbum');
  static String get enterPasswordToAccess => get('enterPasswordToAccess');
  static String get createPassword => get('createPassword');
  static String get enterPasswordToCreate => get('enterPasswordToCreate');
  static String get confirmPassword => get('confirmPassword');
  static String get confirmPasswordMessage => get('confirmPasswordMessage');
  static String get passwordMismatch => get('passwordMismatch');
  static String get frontCameraActive => get('frontCameraActive');
  static String get useFingerprintToUnlock => get('useFingerprintToUnlock');
  static String get biometricAuthError => get('biometricAuthError');
  static String get biometricAuthSuccess => get('biometricAuthSuccess');
  static String get biometricAuthFailed => get('biometricAuthFailed');
  static String get downloadSuccess => get('downloadSuccess');
  static String get downloadFailed => get('downloadFailed');
  static String get close => get('close');
  static String get all => get('all');
  static String get download => get('download');
  static String get downloadImages => get('downloadImages');
  static String get downloadImagesConfirmation => get('downloadImagesConfirmation');
  static String get guestMode => get('guestMode');
  static String get editImage => get('editImage');
  static String get imageEdited => get('imageEdited');
  static String get errorSavingEditedImage => get('errorSavingEditedImage');
  static String get errorOpeningImageEditor => get('errorOpeningImageEditor');
  static String get thumbnailSet => get('thumbnailSet');
  static String get albumNotFound => get('albumNotFound');
  static String get failedToUpdateAlbum => get('failedToUpdateAlbum');
  static String get greatPicture => get('greatPicture');
  static String get checking => get('checking');
  static String get unknownAlbum => get('unknownAlbum');
  static String get live => get('live');
  static String get failedPasswordAttemptsAlbum => get('failedPasswordAttemptsAlbum');
  static String get permissionDenied => get('permissionDenied');
  static String get noAlbumsFound => get('noAlbumsFound');
  static String get failedToInitializeAlbums => get('failedToInitializeAlbums');
  static String get failedToLoadMoreAssets => get('failedToLoadMoreAssets');
  static String get failedToLoadAlbumAssets => get('failedToLoadAlbumAssets');
  static String get idMustBePresent => get('idMustBePresent');
  static String get appLocked => get('appLocked');
  static String get appLockedDueToIncorrectPassword => get('appLockedDueToIncorrectPassword');
  static String get timeRemaining => get('timeRemaining');
  static String get pleaseWaitForLockTime => get('pleaseWaitForLockTime');
}
