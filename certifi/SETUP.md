# CertiFi — Sprint 1 Setup

## Trạng thái hiện tại (đã xong)

- Flutter SDK 3.50.1 stable tại `D:\flutter_windows_3.50.1-stable\flutter`
  (đã thêm `...\flutter\bin` vào User PATH — mở terminal mới để dùng `flutter` trực tiếp).
- Platform folders đã tạo: `android/`, `windows/`, `web/`.
- `flutter pub get` + `build_runner` đã chạy — `student.freezed.dart`,
  `student.g.dart` đã sinh tự động.
- `flutter analyze`: **0 error, 0 warning** (chỉ còn info deprecation
  `material.dart` của Flutter 3.50 — bỏ qua được).
- `flutter test`: pass. `flutter build web`: **build thành công**.

## Chạy app

```powershell
cd D:\certifi\CertiFi\certifi
flutter run -d chrome        # web — chạy được ngay về mặt UI
flutter run -d windows       # cần Visual Studio "Desktop development with C++"
flutter run                  # Android: cần emulator/device + Firebase config
```

> Lưu ý: `firebase_core` **không hỗ trợ Windows desktop** — app chỉ chạy
> thật trên Android/iOS/Web. Trên Chrome, `Firebase.initializeApp()` cần
> `firebase_options.dart` (xem mục Firebase bên dưới).

## Firebase setup — ĐÃ XONG phần config

- Project: `certifi-8d17f` (CertiFi)
- `lib/firebase_options.dart` + `android/app/google-services.json` đã sinh
  bởi `flutterfire configure` (android + web).
- Gradle đã có plugin `com.google.gms.google-services`.
- `main.dart` đã dùng `DefaultFirebaseOptions.currentPlatform`.

## Việc còn lại trong Firebase Console (làm tay)

1. **Authentication** → Sign-in method → bật **Email/Password**
2. **Firestore Database** → Create database (production mode,
   region Singapore gần nhất)
3. Tạo user đăng nhập đầu tiên: Authentication → Users → Add user
   (VD `admin@certifi.edu` / `admin123`)

## Dữ liệu mẫu Firestore

Collection `students`, document mẫu:

```json
{
  "studentCode": "SV001",
  "fullName": "Nguyen Van A",
  "email": "a@student.edu",
  "major": "Software Engineering",
  "age": 20,
  "gpa": 3.5,
  "enrolledAt": "2024-09-01T00:00:00.000"
}
```

Collection `users` (hệ thống) và subcollection
`students/{id}/certificates` cho chứng chỉ.

## TODO cho Sprint sau / đề thi

- [ ] Auth guard: redirect `/login` khi chưa đăng nhập.
- [ ] Student: form Thêm/Sửa SV, sort nhiều tiêu chí, search nâng cao.
- [ ] Certificates: CRUD đầy đủ (hiện chỉ đọc), import/export Excel/CSV.
- [ ] Users: form thêm/sửa (Name, Age, Phone, Status Normal/Locked),
      login history, phân quyền 3 role admin/manager/employee.
- [ ] Import/Export Excel/CSV (package gợi ý: `excel`, `csv`, `file_picker`).
- [ ] Profile: upload avatar thật; `changePassword` cần reauthenticate.
