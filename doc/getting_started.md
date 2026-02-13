# Bắt đầu với Kappa Framework (Getting Started)

Chào mừng bạn đến với Kappa! Hướng dẫn này giúp bạn thiết lập dự án từ đầu.

## 1. Cài đặt

Thêm Kappa vào dự án Flutter:
```bash
flutter pub add kappa
```

## 2. Khởi tạo Dự án
Sau khi thêm package, bạn cần tạo file cấu hình `kappa.yaml`:
```bash
dart run kappa:generate
```
*Lưu ý: Bạn có thể dùng `dart run kappa:generate interactive` và chọn các tùy chọn khởi tạo.*

## 3. Cài đặt Cấu trúc Thư mục
Để tạo các thư mục `core`, `data`, `domain`, `presentation` và các file mẫu:
```bash
dart run kappa install
```

## 4. Kiểm tra Cấu hình (Kappa Doctor)
Sau khi cài đặt, hãy đảm bảo mọi thứ đã sẵn sàng:
```bash
dart run kappa doctor
```
Lệnh này sẽ kiểm tra:
- Sự tồn tại của `kappa.yaml`.
- Các file môi trường `.env`.
- Cấu trúc `pubspec.yaml`.

## 5. Cấu hình Môi trường
Tạo các file `.env.develop` và `.env.product` trong thư mục gốc. Kappa sẽ tự động tải file tương ứng dựa trên cờ `--dart-define=FLAVOR`.

Ví dụ `.env.develop`:
```dotenv
BASE_URL=https://api-dev.example.com
API_KEY=dev_key_123
```

## 6. Khởi chạy App Runner
Trong `main.dart`, sử dụng `Kappa.ensureInitialized` để kích hoạt toàn bộ sức mạnh của framework.

---
Tiếp theo: [Hướng dẫn Sử dụng chi tiết](usage.md)
