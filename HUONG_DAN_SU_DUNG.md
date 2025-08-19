# HƯỚNG DẪN SỬ DỤNG APP PHOTO GUARD

## Tổng quan
Photo Guard là ứng dụng bảo vệ ảnh và video cá nhân với các tính năng bảo mật cao cấp. Ứng dụng cho phép bạn tạo các album riêng tư được bảo vệ bằng mật khẩu và camera giám sát.

## Các chức năng chính

### 1. Màn hình chính (Album List)
- **Xem danh sách album**: Hiển thị tất cả album đã tạo
- **Thêm album mới**: Nhấn vào biểu tượng "+" để tạo album mới
- **Truy cập cài đặt**: Nhấn vào biểu tượng menu (3 gạch ngang) để vào Settings

### 2. Chức năng trong Settings

#### 2.1 Xem lần thử thất bại (View Failed Attempts)
- **Mục đích**: Xem lại các ảnh được chụp khi có người nhập sai mật khẩu
- **Cách sử dụng**: 
  - Vào Settings → nhấn "View Failed Attempts"
  - Xem danh sách ảnh được chụp tự động
  - **Chế độ chọn**: 
    - Nhấn giữ ảnh để vào chế độ chọn
    - Nhấn "Select All" để chọn tất cả
    - Nhấn "Delete" để xóa các ảnh đã chọn
  - **Xem ảnh**: Nhấn vào ảnh để xem chi tiết

#### 2.2 Cài đặt ngôn ngữ (Language)
- **Chuyển đổi ngôn ngữ**: 
  - Nhấn vào "Language" để mở tùy chọn
  - Chọn "English" hoặc "Vietnamese"
  - Ngôn ngữ sẽ được thay đổi ngay lập tức

### 3. Chức năng chụp ảnh khi nhập sai mật khẩu

#### 3.1 Hoạt động tự động
- **Camera trước**: Tự động kích hoạt camera trước khi có người nhập mật khẩu
- **Chụp ảnh**: Tự động chụp ảnh khi:
  - Nhập sai mật khẩu
  - Xác thực sinh trắc học thất bại
  - Có lỗi trong quá trình xác thực
- **Lưu trữ**: Ảnh được lưu vào album "Failed Password Attempts"

#### 3.2 Cảnh báo bảo mật
- **Thông báo**: Hiển thị cảnh báo "Front camera is active" khi camera đang hoạt động
- **Mục đích**: Giúp bạn biết khi nào có người đang cố truy cập vào album

### 4. Các chức năng trong màn hình Album Detail

#### 4.1 Quản lý album (Menu 3 chấm)
- **Đổi tên album (Rename Album)**:
  - Nhấn vào menu → "Rename Album"
  - Nhập tên mới cho album
  - Nhấn "Rename" để lưu

- **Thêm mật khẩu (Add Password)**:
  - Nhấn vào menu → "Add Password"
  - Nhập mật khẩu 6 số
  - Xác nhận lại mật khẩu
  - Album sẽ được bảo vệ

- **Xóa mật khẩu (Remove Password)**:
  - Nhấn vào menu → "Remove Password"
  - Nhập mật khẩu hiện tại để xác nhận
  - Mật khẩu sẽ được xóa

- **Xóa album (Delete Album)**:
  - Nhấn vào menu → "Delete Album"
  - Nếu album có mật khẩu: nhập mật khẩu để xác nhận
  - Nếu không có mật khẩu: xác nhận trực tiếp
  - **Cảnh báo**: Tất cả ảnh trong album sẽ bị xóa vĩnh viễn

#### 4.2 Quản lý ảnh trong album
- **Thêm ảnh**: Nhấn vào nút "+" (Floating Action Button) để thêm ảnh từ thư viện
- **Xem ảnh**: Nhấn vào ảnh để xem chi tiết trong Media Viewer
- **Chế độ chọn**: 
  - Nhấn giữ ảnh để vào chế độ chọn
  - Nhấn "Select All" để chọn tất cả ảnh

#### 4.3 Panel chọn ảnh (Selection Panel)
Khi ở chế độ chọn, panel sẽ hiển thị các tùy chọn:

- **Chia sẻ (Share)**:
  - Chia sẻ ảnh đã chọn với ứng dụng khác
  - Xuất ảnh ra ngoài album

- **Tải xuống (Download)**:
  - Tải ảnh đã chọn về thiết bị
  - Lưu vào thư viện ảnh của thiết bị

- **Chế độ khách (Guest Mode)**:
  - Chỉ hiển thị khi album có mật khẩu
  - Cho phép xem ảnh mà không cần nhập mật khẩu
  - Hữu ích khi muốn cho người khác xem ảnh tạm thời

- **Xóa (Delete)**:
  - Xóa các ảnh đã chọn khỏi album
  - Yêu cầu xác nhận trước khi xóa

### 5. Tính năng bảo mật nâng cao

#### 5.1 Khóa ứng dụng tự động (App Lock)
- **Kích hoạt**: Tự động kích hoạt khi nhập sai mật khẩu nhiều lần
- **Ngưỡng kích hoạt**: App sẽ bị khóa sau 5 lần nhập sai mật khẩu liên tiếp
- **Thời gian khóa tăng dần**:
  - **5 lần sai**: Khóa 5 phút
  - **6 lần sai**: Khóa 15 phút  
  - **7 lần sai**: Khóa 20 phút
  - **8 lần sai**: Khóa 30 phút
  - **9 lần sai**: Khóa 60 phút (1 giờ)
  - **10 lần sai trở lên**: Khóa 24 giờ (1 ngày)
- **Màn hình khóa**: Hiển thị thời gian còn lại và không thể thoát
- **Reset bộ đếm**: Bộ đếm lần thử thất bại sẽ được reset khi nhập đúng mật khẩu
- **Bảo vệ**: Ngăn chặn tấn công brute-force và truy cập trái phép

#### 5.2 Xác thực sinh trắc học
- **Vân tay/Face ID**: Có thể sử dụng vân tay hoặc Face ID thay vì mật khẩu
- **Kích hoạt**: Nhấn vào biểu tượng vân tay khi nhập mật khẩu
- **Bảo mật**: Vẫn chụp ảnh khi xác thực thất bại

#### 5.3 Mật khẩu 6 số
- **Định dạng**: Mật khẩu phải có đúng 6 chữ số
- **Bảo mật**: Mật khẩu được mã hóa trước khi lưu trữ
- **Xác nhận**: Phải nhập lại mật khẩu khi tạo mới

### 6. Lưu ý quan trọng

#### 6.1 Quyền truy cập
- **Thư viện ảnh**: Cần cấp quyền để import ảnh
- **Camera**: Cần cấp quyền để chụp ảnh giám sát
- **Lưu trữ**: Cần quyền để lưu ảnh đã tải xuống

#### 6.2 Bảo mật dữ liệu
- **Mã hóa**: Tất cả mật khẩu được mã hóa trước khi lưu
- **Camera giám sát**: Hoạt động tự động để bảo vệ
- **Xóa dữ liệu**: Dữ liệu bị xóa vĩnh viễn, không thể khôi phục

#### 6.3 Sử dụng hiệu quả
- **Tạo album riêng biệt**: Phân loại ảnh theo mục đích sử dụng
- **Đặt mật khẩu mạnh**: Sử dụng mật khẩu khó đoán
- **Kiểm tra lần thử thất bại**: Thường xuyên kiểm tra để phát hiện xâm nhập
- **Sao lưu dữ liệu**: Tải xuống ảnh quan trọng để sao lưu
- **Lưu ý về App Lock**: Tránh nhập sai mật khẩu nhiều lần để không bị khóa app

## Hỗ trợ
Nếu gặp vấn đề khi sử dụng, vui lòng:
1. Kiểm tra quyền truy cập trong Settings
2. Đảm bảo thiết bị có đủ dung lượng lưu trữ
3. Khởi động lại ứng dụng nếu cần thiết

---

# PHOTO GUARD APP USER GUIDE

## Overview
Photo Guard is a personal photo and video protection app with advanced security features. The app allows you to create private albums protected by passwords and surveillance cameras.

## Main Features

### 1. Main Screen (Album List)
- **View album list**: Display all created albums
- **Add new album**: Press the "+" icon to create a new album
- **Access settings**: Press the menu icon (3 horizontal lines) to go to Settings

### 2. Settings Functions

#### 2.1 View Failed Attempts
- **Purpose**: View photos captured when someone enters wrong password
- **How to use**: 
  - Go to Settings → press "View Failed Attempts"
  - View list of automatically captured photos
  - **Selection mode**: 
    - Long press photo to enter selection mode
    - Press "Select All" to select all
    - Press "Delete" to delete selected photos
  - **View photo**: Press photo to view details

#### 2.2 Language Settings
- **Switch language**: 
  - Press "Language" to open options
  - Choose "English" or "Vietnamese"
  - Language will change immediately

### 3. Camera Function When Wrong Password

#### 3.1 Automatic Operation
- **Front camera**: Automatically activates front camera when someone enters password
- **Capture photos**: Automatically capture photos when:
  - Wrong password is entered
  - Biometric authentication fails
  - Error occurs during authentication
- **Storage**: Photos are saved to "Failed Password Attempts" album

#### 3.2 Security Alert
- **Notification**: Display warning "Front camera is active" when camera is operating
- **Purpose**: Help you know when someone is trying to access your album

### 4. Album Detail Screen Functions

#### 4.1 Album Management (3-dot Menu)
- **Rename Album**:
  - Press menu → "Rename Album"
  - Enter new album name
  - Press "Rename" to save

- **Add Password**:
  - Press menu → "Add Password"
  - Enter 6-digit password
  - Confirm password again
  - Album will be protected

- **Remove Password**:
  - Press menu → "Remove Password"
  - Enter current password to confirm
  - Password will be removed

- **Delete Album**:
  - Press menu → "Delete Album"
  - If album has password: enter password to confirm
  - If no password: confirm directly
  - **Warning**: All photos in album will be permanently deleted

#### 4.2 Photo Management in Album
- **Add photos**: Press "+" (Floating Action Button) to add photos from library
- **View photos**: Press photo to view details in Media Viewer
- **Selection mode**: 
  - Long press photo to enter selection mode
  - Press "Select All" to select all photos

#### 4.3 Selection Panel
When in selection mode, panel will display options:

- **Share**:
  - Share selected photos with other apps
  - Export photos outside album

- **Download**:
  - Download selected photos to device
  - Save to device photo library

- **Guest Mode**:
  - Only displayed when album has password
  - Allow viewing photos without entering password
  - Useful for temporarily showing photos to others

- **Delete**:
  - Delete selected photos from album
  - Requires confirmation before deletion

### 5. Advanced Security Features

#### 5.1 Automatic App Lock
- **Activation**: Automatically activates when wrong password is entered multiple times
- **Activation threshold**: App will be locked after 5 consecutive wrong password attempts
- **Escalating lock duration**:
  - **5 wrong attempts**: Lock for 5 minutes
  - **6 wrong attempts**: Lock for 15 minutes  
  - **7 wrong attempts**: Lock for 20 minutes
  - **8 wrong attempts**: Lock for 30 minutes
  - **9 wrong attempts**: Lock for 60 minutes (1 hour)
  - **10+ wrong attempts**: Lock for 24 hours (1 day)
- **Lock screen**: Shows remaining time and cannot be exited
- **Counter reset**: Failed attempt counter resets when correct password is entered
- **Protection**: Prevents brute-force attacks and unauthorized access

#### 5.2 Biometric Authentication
- **Fingerprint/Face ID**: Can use fingerprint or Face ID instead of password
- **Activation**: Press fingerprint icon when entering password
- **Security**: Still captures photos when authentication fails

#### 5.3 6-Digit Password
- **Format**: Password must be exactly 6 digits
- **Security**: Password is encrypted before storage
- **Confirmation**: Must re-enter password when creating new one

### 6. Important Notes

#### 6.1 Access Permissions
- **Photo library**: Need to grant permission to import photos
- **Camera**: Need to grant permission for surveillance photos
- **Storage**: Need permission to save downloaded photos

#### 6.2 Data Security
- **Encryption**: All passwords are encrypted before saving
- **Surveillance camera**: Operates automatically for protection
- **Data deletion**: Data is permanently deleted, cannot be recovered

#### 6.3 Effective Use
- **Create separate albums**: Categorize photos by purpose
- **Set strong passwords**: Use hard-to-guess passwords
- **Check failed attempts**: Regularly check to detect intrusions
- **Backup data**: Download important photos for backup
- **App Lock note**: Avoid entering wrong password multiple times to prevent app lock

## Support
If you encounter problems when using:
1. Check access permissions in Settings
2. Ensure device has sufficient storage space
3. Restart the app if necessary