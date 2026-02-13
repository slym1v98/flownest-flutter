# Kappa Plugin

Một plugin Flutter mạnh mẽ cung cấp giải pháp toàn diện cho Clean Architecture, quản lý trạng thái, và bộ công cụ CLI thông minh để tăng tốc độ phát triển.

[![pub version](https://img.shields.io/pub/v/kappa.svg)](https://pub.dev/packages/kappa)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Tính năng nổi bật

*   **⚡ CLI Tương tác:** Không cần nhớ lệnh phức tạp, chỉ cần `dart run kappa:generate interactive`.
*   **🏗️ Clean Architecture:** Tự động hóa việc tạo tầng Data, Domain, Presentation.
*   **🌐 Global Loader & UI:** Tích hợp sẵn Overlay Loader, Theme management và Connectivity handling.
*   **💉 DI & Service Locator:** Quản lý dependency dễ dàng với hệ thống `SL` được tối ưu.
*   **🛠️ Tiện ích phát triển:** Các lệnh hỗ trợ `build`, `watch`, và `doctor` để kiểm tra dự án.

## Cài đặt

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  kappa: ^latest_version
```

Sau đó chạy: `flutter pub get`

## Sử dụng CLI (Cực kỳ quan trọng)

Kappa cung cấp bộ công cụ dòng lệnh mạnh mẽ để khởi tạo và quản lý dự án.

### 1. Chế độ Tương tác (Khuyên dùng)
Dễ dàng tạo Feature, Model, Screen... qua giao diện hỏi-đáp:
```bash
dart run kappa:generate interactive
```

### 2. Các lệnh tiện ích
Thay vì gõ lệnh dài của Flutter, Kappa cung cấp các phím tắt:
*   `dart run kappa build`: Chạy build_runner một lần.
*   `dart run kappa watch`: Chạy build_runner ở chế độ theo dõi.
*   `dart run kappa doctor`: Kiểm tra cấu hình và sức khỏe của dự án.
*   `dart run kappa install`: Khởi tạo cấu trúc dự án Kappa lần đầu.

## Sử dụng Runtime

### Khởi tạo App
```dart
void main() async {
  await Kappa.ensureInitialized(
    designSize: const Size(390, 844),
    routerDelegate: appRouter.delegate(),
    routeInformationParser: appRouter.defaultRouteParser(),
    // ... các cấu hình khác
  );
}
```

### Sử dụng Global Loader
Để hiển thị/ẩn loading toàn màn hình từ bất kỳ đâu:
```dart
SL.call<LoaderCubit>().setLoading(true); // Hiện loading
SL.call<LoaderCubit>().setLoading(false); // Ẩn loading
```

---
Xem chi tiết tại thư mục [/doc](doc/getting_started.md).
