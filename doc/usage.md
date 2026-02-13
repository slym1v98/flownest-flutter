# Hướng dẫn Sử dụng (Usage Guide)

Tài liệu này hướng dẫn chi tiết cách sử dụng các thành phần của Kappa Framework.

## 1. Công cụ Dòng lệnh (CLI)

Kappa CLI được thiết kế để giảm thiểu công việc lặp đi lặp lại.

### 1.1. Trình tạo mã Tương tác (Interactive Generator)
Thay vì sử dụng các cờ (flags) phức tạp, bạn có thể chạy:
```bash
dart run kappa:generate interactive
```
Bạn sẽ được lựa chọn:
- **Feature**: Tạo toàn bộ các tầng Clean Architecture (Data, Domain, Presentation).
- **Model**: Tạo Data Model với JSON serialization.
- **Screen**: Tạo StatelessWidget hoặc StatefulWidget.
- **Bloc/Cubit**: Tạo quản lý trạng thái.
- **Repository**: Tạo interface và implementation.

### 1.3. Tạo Feature từ API Schema (Cao cấp)
Đây là tính năng mạnh mẽ nhất của Kappa, cho phép tạo toàn bộ Feature từ một file JSON mô tả.
```bash
dart run kappa api your_schema.json
```
**Khả năng của lệnh:**
- Tự động tạo cấu trúc thư mục Clean Architecture.
- Sinh class **Entity** với các trường dữ liệu động.
- Sinh class **Model** kèm logic `toEntity()` và xử lý giá trị mặc định.
- Sinh **RemoteDataSource** interface.
- Sinh **Repository Interface** và **Implementation**.
- Sinh **UseCases** cho từng endpoint.
- Sinh file **DI Registration** (`<feature>_di.dart`) để đăng ký nhanh các dịch vụ vào Service Locator.

**Cách tích hợp nhanh Feature vừa tạo:**
Mở file `lib/src/injector.dart` và gọi:
```dart
UserDI.init(); // Với "User" là tên feature bạn vừa generate
```

## 2. Thành phần Runtime

### 2.1. Global Loader Overlay
Kappa tích hợp sẵn một lớp phủ Loading toàn cục trong `KappaMaterialApp`.
- **Cách dùng**: Truy cập `LoaderCubit` qua Service Locator.
- **Code**: `SL.call<LoaderCubit>().setLoading(true);`

### 2.2. BaseSimpleUseCase
Ngoài `BaseUseCase` truyền thống trả về `SingleOrList`, bạn có thể dùng `BaseSimpleUseCase` để trả về bất kỳ kiểu dữ liệu nào (ví dụ: `bool`, `void`, hoặc một Entity đơn lẻ).

```dart
class MyUseCase extends BaseSimpleUseCase<BaseException, bool, MyParams> {
  @override
  Future<Either<BaseException, bool>> execute(MyParams params) async {
    // logic ở đây
  }
}
```

### 2.3. Quản lý Service Locator (SL)
Đăng ký dịch vụ cho từng Feature một cách gọn gàng:
```dart
SL.initFeatureServices((i) {
  i.registerLazySingleton<MyService>(() => MyServiceImpl());
});
```

## 3. Quản lý Môi trường
Chạy ứng dụng với các môi trường khác nhau:
```bash
# Môi trường Develop
flutter run --flavor develop --dart-define=FLAVOR=develop

# Môi trường Production
flutter run --flavor product --dart-define=FLAVOR=product
```
