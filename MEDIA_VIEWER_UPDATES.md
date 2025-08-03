# Media Viewer Updates - Hỗ trợ Video và Image

## Tổng quan
Đã cập nhật hệ thống để hỗ trợ cả video và image trong media viewer với các tính năng sau:

### 1. Cập nhật Import Media
- **File**: `lib/presentation/features/import_media/cubit/import_media_cubit.dart`
- **Thay đổi**: Sử dụng `RequestType.common` để load cả image và video
- **Logic**: Tự động xác định loại file (image/video) dựa trên `AssetType`

### 2. Cập nhật Album Detail Cubit
- **File**: `lib/presentation/features/album_detail/album_detail_cubit.dart`
- **Thay đổi**: Logic xác định file type khi import
```dart
// Determine file type based on asset type
GuardFileType fileType = GuardFileType.image;
if (asset.type == AssetType.video) {
  fileType = GuardFileType.video;
}
```

### 3. Tạo MediaViewerCubit
- **File**: `lib/presentation/features/media_viewer/cubit/media_viewer_cubit.dart`
- **Chức năng**:
  - Quản lý state của media viewer
  - Xử lý set thumbnail
  - Xử lý edit image (chỉ cho image files)
  - Phân biệt loại media (image/video)

### 4. Cập nhật MediaViewerScreen
- **File**: `lib/presentation/features/media_viewer/media_viewer_screen.dart`
- **Tính năng mới**:
  - Hỗ trợ video player với overlay play button
  - Video không có zoom/pan, chỉ có play/pause
  - Image có đầy đủ tính năng zoom/pan/edit
  - Menu context chỉ hiển thị edit cho image files

### 5. Cập nhật UI Components
- **File List Grid**: Hiển thị icon play cho video files
- **Import Media**: Hiển thị icon play cho video files
- **Video Player**: Sử dụng `video_player` package với overlay controls

### 6. Video Features
- **Không zoom/pan**: Video chỉ hiển thị với aspect ratio gốc
- **Play overlay**: Nút play ở giữa khi video chưa phát
- **Không edit**: Video không có tùy chọn edit
- **Auto-initialize**: Tự động khởi tạo video controllers

### 7. Image Features
- **Zoom/Pan**: Hỗ trợ zoom từ 1.0x đến 5.0x
- **Edit**: Có thể edit image với ProImageEditor
- **Set thumbnail**: Có thể set làm thumbnail cho album

## Cấu trúc Files
```
lib/presentation/features/media_viewer/
├── cubit/
│   ├── media_viewer_cubit.dart
│   └── media_viewer_state.dart
└── media_viewer_screen.dart
```

## Dependencies
- `video_player: ^2.10.0` - Đã có sẵn trong pubspec.yaml
- `photo_manager: ^3.7.1` - Hỗ trợ RequestType.common

## Testing
- Chạy `flutter analyze` - Không có lỗi
- Chạy `flutter packages pub run build_runner build` - Generate code thành công
- Tất cả imports đã được cập nhật đúng

## Lưu ý
- Video files sẽ hiển thị icon play trong grid view
- Video không thể edit, chỉ có thể play/pause
- Image files vẫn có đầy đủ tính năng như trước
- Menu context tự động ẩn/hiện tùy theo loại media 