# Student Management App — Sprint: Chuẩn hóa Repo, Hợp đồng Kiến trúc (A ↔ B) & Checklist Giảng viên

Tài liệu kỹ thuật và bộ mã nguồn Production-Ready cho Sprint thiết lập nền tảng làm việc nhóm giữa **Dev A (UI/Presentation)** và **Dev B (Data/Firebase)**, áp dụng tuyệt đối **Clean Architecture + Feature-First**, **Data Table chuẩn**, **Typography (`Inter` + `JetBrains Mono tabular-nums`)**, **Micro-interactions (`150ms–250ms`)** và **4 trạng thái DoD**.

## 1. Cấu trúc File cần tạo mới / sửa đổi

```text
student_management_app/
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md          # [MỚI] Checklist DoD 4 trạng thái & quy tắc UI trước khi merge
│   └── workflows/
│       └── ci.yml                        # [MỚI] Tự động chạy flutter analyze, test & kiểm tra codegen
├── docs/
│   └── lecturer_qa_checklist.md          # [MỚI] Danh sách câu hỏi chốt nghiệp vụ mơ hồ với giảng viên
├── CONTRIBUTING.md                       # [MỚI] Quy ước Git Branching & Conventional Commits giữa A và B
├── lib/
│   ├── core/
│   │   ├── errors/
│   │   │   └── app_failure.dart          # [MỚI] Freezed union chuẩn hóa lỗi (chặn rò rỉ FirebaseException)
│   │   ├── models/
│   │   │   └── bulk_action_result.dart   # [MỚI] Model kết quả xử lý Bulk Actions (hỗ trợ partial failure)
│   │   └── providers/
│   │       └── repository_providers.dart # [MỚI] Điểm gắn kết DI duy nhất giữa A (UI) và B (Data)
│   └── features/
│       ├── auth/
│       │   └── domain/
│       │       ├── entities/auth_session.dart            # [MỚI] Freezed entity
│       │       └── repositories/auth_repository.dart     # [MỚI] Hợp đồng Auth (A ↔ B)
│       ├── users/
│       │   └── domain/
│       │       ├── entities/app_user.dart                # [MỚI] Freezed entity (Role & Status)
│       │       └── repositories/user_repository.dart     # [MỚI] Hợp đồng User Management (A ↔ B)
│       ├── students/
│       │   └── domain/
│       │       ├── entities/student.dart                 # [SỬA] Bổ sung status, updatedAt chuẩn hóa
│       │       └── repositories/student_repository.dart  # [SỬA] Bổ sung hợp đồng Filter, Sort, Bulk
│       └── certificates/
│           ├── data/
│           │   └── repositories/fake_certificate_repository.dart # [MỚI] Mock chuẩn hợp đồng cho A code UI độc lập
│           ├── domain/
│           │   ├── entities/certificate.dart                     # [MỚI] Freezed entity
│           │   └── repositories/certificate_repository.dart      # [MỚI] Hợp đồng Certificate (A ↔ B)
│           └── presentation/
│               ├── providers/certificate_providers.dart          # [MỚI] Riverpod AsyncNotifier chỉ gọi Interface
│               └── screens/certificate_list_screen.dart          # [MỚI] Màn hình Data Table đủ 4 trạng thái DoD
└── pubspec.yaml                          # [SỬA] Đồng bộ phiên bản riverpod, freezed, json_serializable
```

## 2. Quy ước GitHub Repo, Branch & Commit (`CONTRIBUTING.md`)

```markdown
# Quy ước Git Workflow (Dev A & Dev B)

## 1. Cấu trúc nhánh (Branching Strategy)
- `main`: Nhánh production ổn định, chỉ merge từ `develop` qua Pull Request (bắt buộc pass CI).
- `develop`: Nhánh tích hợp chung giữa A và B.
- Nhánh tính năng: `feat/<owner>/<feature>-<short-desc>`
  - Ví dụ Dev A (UI): `feat/a/certificates-table-ui`
  - Ví dụ Dev B (Data): `feat/b/certificates-firestore-repo`
- Nhánh sửa lỗi: `fix/<owner>/<issue-desc>`
- Nhánh thay đổi hợp đồng Domain: `chore/contract-<entity>` (BẮT BUỘC cả A và B cùng review trước khi merge).

## 2. Quy ước Commit (Conventional Commits)
Cú pháp: `<type>(<scope>): <mô tả ngắn không quá 72 ký tự>`
- `feat(students): add bulk delete bar with 200ms slide transition`
- `fix(certificates): clamp tabular-nums column width on narrow viewports`
- `refactor(domain): standardize AppFailure union across repositories`
- `chore(ci): enforce dart analyze and freezed verification on PR`

## 3. Quy tắc chống xung đột Codegen (`*.freezed.dart`, `*.g.dart`)
- KHÔNG sửa tay file `*.freezed.dart` và `*.g.dart`.
- Luôn chốt và merge nhánh `chore/contract-*` vào `develop` trước khi A và B tách nhánh feature song song.
- Chạy lệnh sau trước khi push:
  `dart run build_runner build --delete-conflicting-outputs && dart analyze`
```

## 3. Checklist họp trao đổi với Giảng viên (`docs/lecturer_qa_checklist.md`)

| Nhóm nghiệp vụ | Điểm mơ hồ cần làm rõ với Giảng viên | Phương án mặc định đề xuất (nếu giảng viên giao tự quyết) |
| :--- | :--- | :--- |
| **Phân quyền (RBAC)** | Hệ thống có mấy vai trò (`Admin`, `Manager`, `Employee`)? Vai trò `Employee` có được xem bảng `User List` hoặc bấm `Bulk Delete` không? | `Admin`: toàn quyền; `Manager`: CRUD Student & Certificate, chỉ xem User; `Employee`: chỉ xem Student & Certificate, ẩn nút Bulk Delete. |
| **Xóa dữ liệu & Toàn vẹn** | Khi xóa một `Student` (đặc biệt qua Bulk Delete), các `Certificate` của sinh viên đó bị xóa theo (Cascade Delete), xóa mềm (`isDeleted = true`), hay chặn xóa? | Dùng **Soft Delete** (`archivedAt`) cho Student và tự động gắn cờ lưu trữ cho Certificate liên quan để giữ lịch sử tra cứu. |
| **Thang điểm GPA & Chứng chỉ** | GPA dùng thang `4.00` hay thang `10.00`? Chứng chỉ có ngày hết hạn (`expiredAt`) và điểm số (`score`) bắt buộc hay tùy chọn? | GPA thang `4.00` (hiển thị đúng 2 chữ số thập phân bằng `JetBrains Mono tabular-nums`); `expiredAt` cho phép `null` (vô thời hạn). |
| **Tài khoản & Khởi tạo User** | Khi Admin tạo mới `User` trên app, có dùng Firebase Admin SDK / Cloud Function để không bị đăng xuất phiên Admin hiện tại, hay dùng Secondary `FirebaseApp`? | Dùng Secondary `FirebaseApp` phía client (nếu không triển khai Cloud Functions) để tạo Auth user mà không mất phiên Admin. |
| **Import / Export & Tìm kiếm** | Có yêu cầu Import/Export CSV/Excel cho Student & Certificate không? Tìm kiếm cần Full-text hay chỉ lọc theo Mã SV, Họ tên, Email? | Hỗ trợ Export CSV từ danh sách đang chọn (Bulk Action); tìm kiếm chuẩn hóa chữ thường theo Mã SV, Họ tên, Email. |

## 4. Mã nguồn Hoàn chỉnh (Production-Ready Code)

### 4.1. Hợp đồng Lỗi & Kết quả Bulk Actions (`lib/core/errors/app_failure.dart`, `lib/core/models/bulk_action_result.dart`)

```dart
// lib/core/errors/app_failure.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

/// Hợp đồng lỗi duy nhất giữa tầng Data (Dev B) và tầng Presentation (Dev A).
/// Tuyệt đối không để FirebaseException hay SocketException rò rỉ lên UI.
@freezed
sealed class AppFailure with _$AppFailure implements Exception {
  const AppFailure._();

  const factory AppFailure.network({
    @Default('Mất kết nối mạng. Vui lòng kiểm tra đường truyền và thử lại.')
    String message,
  }) = NetworkFailure;

  const factory AppFailure.permissionDenied({
    @Default('Bạn không có quyền thực hiện thao tác này.') String message,
  }) = PermissionDeniedFailure;

  const factory AppFailure.notFound({
    required String entityName,
    required String entityId,
  }) = NotFoundFailure;

  const factory AppFailure.validation({
    required String field,
    required String message,
  }) = ValidationFailure;

  const factory AppFailure.conflict({
    required String message,
  }) = ConflictFailure;

  const factory AppFailure.unknown({
    @Default('Đã xảy ra lỗi cơ sở dữ liệu không xác định.') String message,
    Object? rawError,
  }) = UnknownFailure;

  String get userMessage => when(
        network: (msg) => msg,
        permissionDenied: (msg) => msg,
        notFound: (entity, id) => 'Không tìm thấy $entity với mã "$id".',
        validation: (field, msg) => '$field: $msg',
        conflict: (msg) => msg,
        unknown: (msg, _) => msg,
      );
}
```

```dart
// lib/core/models/bulk_action_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_action_result.freezed.dart';
part 'bulk_action_result.g.dart';

/// Kết quả trả về cho mọi thao tác Bulk Actions (Xóa hàng loạt / Cập nhật hàng loạt)
@freezed
class BulkActionResult with _$BulkActionResult {
  const BulkActionResult._();

  const factory BulkActionResult({
    required int totalRequested,
    required List<String> succeededIds,
    required Map<String, String> failedReasons,
  }) = _BulkActionResult;

  bool get isFullSuccess => failedReasons.isEmpty;
  bool get isPartialSuccess =>
      succeededIds.isNotEmpty && failedReasons.isNotEmpty;

  factory BulkActionResult.fromJson(Map<String, dynamic> json) =>
      _$BulkActionResultFromJson(json);
}
```

### 4.2. Hợp đồng Kiến trúc Domain giữa Dev A và Dev B (Entities + Abstract Repositories)

#### A. Feature `auth` — `AuthRepository`

```dart
// lib/features/auth/domain/entities/auth_session.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

enum UserRole { admin, manager, employee }

@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String uid,
    required String email,
    required String displayName,
    required UserRole role,
    required DateTime signedInAt,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
```

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import '../entities/auth_session.dart';

abstract class AuthRepository {
  Stream<AuthSession?> watchAuthState();
  Future<AuthSession?> getCurrentSession();
  Future<AuthSession> signInWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
```

#### B. Feature `users` — `AppUser` & `UserRepository`

```dart
// lib/features/users/domain/entities/app_user.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../auth/domain/entities/auth_session.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

enum AccountStatus { active, locked }

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String employeeCode,
    required String fullName,
    required String email,
    required String phoneNumber,
    required UserRole role,
    required AccountStatus status,
    required DateTime lastLoginAt,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
```

```dart
// lib/features/users/domain/repositories/user_repository.dart
import '../../../../core/models/bulk_action_result.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../entities/app_user.dart';

abstract class UserRepository {
  Future<List<AppUser>> getUsers({
    String? searchQuery,
    UserRole? roleFilter,
    AccountStatus? statusFilter,
  });

  Future<AppUser> getUserById(String userId);
  Future<AppUser> createUser(AppUser user, {required String initialPassword});
  Future<AppUser> updateUser(AppUser user);
  Future<BulkActionResult> updateStatusBulk({
    required Set<String> userIds,
    required AccountStatus status,
  });
  Future<BulkActionResult> deleteUsersBulk(Set<String> userIds);
}
```

#### C. Feature `students` — `StudentRepository`

```dart
// lib/features/students/domain/repositories/student_repository.dart
import '../../../../core/models/bulk_action_result.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents({
    String? searchQuery,
    String? majorFilter,
    double? minGpa,
  });

  Future<Student> getStudentById(String studentId);
  Future<Student> createStudent(Student student);
  Future<Student> updateStudent(Student student);
  Future<BulkActionResult> deleteStudentsBulk(Set<String> studentIds);
}
```

#### D. Feature `certificates` — `Certificate` & `CertificateRepository`

```dart
// lib/features/certificates/domain/entities/certificate.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'certificate.freezed.dart';
part 'certificate.g.dart';

enum CertificateStatus { valid, expired, revoked }

@freezed
class Certificate with _$Certificate {
  const factory Certificate({
    required String id,
    required String certificateCode,
    required String studentCode,
    required String studentName,
    required String title,
    required String issuer,
    required double score,
    required CertificateStatus status,
    required DateTime issuedAt,
    DateTime? expiredAt,
  }) = _Certificate;

  factory Certificate.fromJson(Map<String, dynamic> json) =>
      _$CertificateFromJson(json);
}
```

```dart
// lib/features/certificates/domain/repositories/certificate_repository.dart
import '../../../../core/models/bulk_action_result.dart';
import '../entities/certificate.dart';

abstract class CertificateRepository {
  Future<List<Certificate>> getCertificates({
    String? studentCode,
    String? searchQuery,
    CertificateStatus? statusFilter,
  });

  Future<Certificate> createCertificate(Certificate certificate);
  Future<Certificate> updateCertificate(Certificate certificate);
  Future<BulkActionResult> revokeCertificatesBulk(Set<String> certificateIds);
  Future<BulkActionResult> deleteCertificatesBulk(Set<String> certificateIds);
}
```

### 4.3. Điểm gắn kết DI (`repository_providers.dart`) & Mock Repository cho Dev A làm việc song song

```dart
// lib/core/providers/repository_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/certificates/data/repositories/fake_certificate_repository.dart';
import '../../features/certificates/domain/repositories/certificate_repository.dart';

/// Chế độ chạy Mock cho Dev A kiểm thử UI đủ 4 trạng thái DoD khi Dev B đang code Firebase
enum ContractSimulationMode { happyPath, empty, networkError }

final contractSimulationModeProvider =
    StateProvider<ContractSimulationMode>((ref) => ContractSimulationMode.happyPath);

/// Khi Dev B hoàn thành `FirebaseCertificateRepository`, chỉ cần đổi 1 dòng tại đây.
/// Toàn bộ tầng Presentation (UI + Notifier) giữ nguyên 100%.
final certificateRepositoryProvider = Provider<CertificateRepository>((ref) {
  final mode = ref.watch(contractSimulationModeProvider);
  return FakeCertificateRepository(mode: mode);
});
```

```dart
// lib/features/certificates/data/repositories/fake_certificate_repository.dart
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/certificate.dart';
import '../../domain/repositories/certificate_repository.dart';

class FakeCertificateRepository implements CertificateRepository {
  final ContractSimulationMode mode;

  FakeCertificateRepository({required this.mode});

  static final List<Certificate> _store = [
    Certificate(
      id: 'cert_01',
      certificateCode: 'CERT-2026-0001',
      studentCode: '52200101',
      studentName: 'Nguyễn Minh Khôi',
      title: 'IELTS Academic 7.5 — Chứng chỉ ngoại ngữ chuẩn đầu ra',
      issuer: 'British Council Vietnam',
      score: 7.50,
      status: CertificateStatus.valid,
      issuedAt: DateTime(2026, 3, 14),
      expiredAt: DateTime(2028, 3, 14),
    ),
    Certificate(
      id: 'cert_02',
      certificateCode: 'CERT-2026-0002',
      studentCode: '52200148',
      studentName: 'Trần Thị Bảo Ngọc',
      title: 'AWS Certified Cloud Practitioner (CLF-C02)',
      issuer: 'Amazon Web Services Training & Certification',
      score: 892.00,
      status: CertificateStatus.valid,
      issuedAt: DateTime(2026, 6, 2),
      expiredAt: DateTime(2029, 6, 2),
    ),
    Certificate(
      id: 'cert_03',
      certificateCode: 'CERT-2024-0819',
      studentCode: '52100422',
      studentName: 'Lê Hoàng Gia Bảo',
      title: 'MOS Microsoft Office Specialist Excel Expert',
      issuer: 'IIG Vietnam',
      score: 940.00,
      status: CertificateStatus.expired,
      issuedAt: DateTime(2024, 1, 20),
      expiredAt: DateTime(2026, 1, 20),
    ),
  ];

  @override
  Future<List<Certificate>> getCertificates({
    String? studentCode,
    String? searchQuery,
    CertificateStatus? statusFilter,
  }) async {
    // Giả lập độ trễ mạng Firebase để kiểm thử Skeleton Loading
    await Future<void>.delayed(const Duration(milliseconds: 650));

    if (mode == ContractSimulationMode.networkError) {
      throw const AppFailure.network();
    }
    if (mode == ContractSimulationMode.empty) {
      return const [];
    }

    return _store.where((cert) {
      if (studentCode != null && cert.studentCode != studentCode) return false;
      if (statusFilter != null && cert.status != statusFilter) return false;
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        final q = searchQuery.trim().toLowerCase();
        return cert.certificateCode.toLowerCase().contains(q) ||
            cert.studentCode.toLowerCase().contains(q) ||
            cert.studentName.toLowerCase().contains(q) ||
            cert.title.toLowerCase().contains(q);
      }
      return true;
    }).toList();
  }

  @override
  Future<Certificate> createCertificate(Certificate certificate) async {
    _store.insert(0, certificate);
    return certificate;
  }

  @override
  Future<Certificate> updateCertificate(Certificate certificate) async {
    final idx = _store.indexWhere((c) => c.id == certificate.id);
    if (idx == -1) {
      throw AppFailure.notFound(entityName: 'chứng chỉ', entityId: certificate.id);
    }
    _store[idx] = certificate;
    return certificate;
  }

  @override
  Future<BulkActionResult> revokeCertificatesBulk(
    Set<String> certificateIds,
  ) async {
    final succeeded = <String>[];
    final failed = <String, String>{};

    for (final id in certificateIds) {
      final idx = _store.indexWhere((c) => c.id == id);
      if (idx == -1) {
        failed[id] = 'Không tìm thấy bản ghi';
        continue;
      }
      _store[idx] = _store[idx].copyWith(status: CertificateStatus.revoked);
      succeeded.add(id);
    }

    return BulkActionResult(
      totalRequested: certificateIds.length,
      succeededIds: succeeded,
      failedReasons: failed,
    );
  }

  @override
  Future<BulkActionResult> deleteCertificatesBulk(
    Set<String> certificateIds,
  ) async {
    final succeeded = <String>[];
    final failed = <String, String>{};

    for (final id in certificateIds) {
      final before = _store.length;
      _store.removeWhere((c) => c.id == id);
      if (_store.length < before) {
        succeeded.add(id);
      } else {
        failed[id] = 'Bản ghi đã bị xóa trước đó';
      }
    }

    return BulkActionResult(
      totalRequested: certificateIds.length,
      succeededIds: succeeded,
      failedReasons: failed,
    );
  }
}
```

### 4.4. Riverpod Notifier & Màn hình `CertificateListScreen` (Áp dụng đầy đủ Typography, Skeleton Loading & 4 trạng thái DoD)

```dart
// lib/features/certificates/presentation/providers/certificate_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/certificate.dart';

final certificateSearchProvider = StateProvider<String>((ref) => '');
final selectedCertificateIdsProvider = StateProvider<Set<String>>((ref) => {});

final certificateListNotifierProvider =
    AsyncNotifierProvider<CertificateListNotifier, List<Certificate>>(
  CertificateListNotifier.new,
);

class CertificateListNotifier extends AsyncNotifier<List<Certificate>> {
  int _requestVersion = 0;

  @override
  Future<List<Certificate>> build() async {
    final version = ++_requestVersion;
    final query = ref.watch(certificateSearchProvider);
    final repo = ref.watch(certificateRepositoryProvider);

    final items = await repo.getCertificates(searchQuery: query);

    // Chặn Race Condition: bỏ qua kết quả cũ nếu người dùng vừa đổi bộ lọc
    if (version != _requestVersion) {
      return state.valueOrNull ?? items;
    }

    // Dọn dẹp Ghost Selection
    final validIds = items.map((e) => e.id).toSet();
    final currentSelected = ref.read(selectedCertificateIdsProvider);
    final sanitized = currentSelected.intersection(validIds);
    if (sanitized.length != currentSelected.length) {
      Future.microtask(() {
        ref.read(selectedCertificateIdsProvider.notifier).state = sanitized;
      });
    }

    return items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final query = ref.read(certificateSearchProvider);
      return ref
          .read(certificateRepositoryProvider)
          .getCertificates(searchQuery: query);
    });
  }

  Future<BulkActionResult> revokeSelected(Set<String> ids) async {
    final result = await ref
        .read(certificateRepositoryProvider)
        .revokeCertificatesBulk(ids);
    ref.read(selectedCertificateIdsProvider.notifier).state = {};
    await refresh();
    return result;
  }

  Future<BulkActionResult> deleteSelected(Set<String> ids) async {
    final result = await ref
        .read(certificateRepositoryProvider)
        .deleteCertificatesBulk(ids);
    ref.read(selectedCertificateIdsProvider.notifier).state = {};
    await refresh();
    return result;
  }
}
```

```dart
// lib/features/certificates/presentation/screens/certificate_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_data_table.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/dod_state_builder.dart';
import '../../../../core/widgets/scale_button.dart';
import '../../../../core/widgets/shake_widget.dart';
import '../../domain/entities/certificate.dart';
import '../providers/certificate_providers.dart';

/// Màn hình quản lý Chứng chỉ: chỉ giao tiếp với CertificateRepository qua Riverpod.
/// Đáp ứng 100%: Data Table (Sticky Header, Truncation Tooltip, Bulk Actions),
/// Inter + JetBrains Mono (tabular-nums), Skeleton Loading và 4 trạng thái DoD.
class CertificateListScreen extends ConsumerStatefulWidget {
  const CertificateListScreen({super.key});

  @override
  ConsumerState<CertificateListScreen> createState() =>
      _CertificateListScreenState();
}

class _CertificateListScreenState extends ConsumerState<CertificateListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ShakeController _searchShakeCtrl = ShakeController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _submitSearch(String value) {
    if (value.contains(RegExp(r'[<>{};]'))) {
      _searchShakeCtrl.shake(); // Shake 150ms khi lỗi validation
      AppToast.show(
        context,
        message: 'Từ khóa tìm kiếm chứa ký tự không hợp lệ.',
        type: ToastType.error,
      );
      return;
    }
    ref.read(certificateSearchProvider.notifier).state = value;
  }

  Future<void> _handleBulkRevoke(Set<String> ids) async {
    try {
      final result = await ref
          .read(certificateListNotifierProvider.notifier)
          .revokeSelected(ids);
      if (!mounted) return;

      if (result.isFullSuccess) {
        AppToast.show(
          context,
          message: 'Đã thu hồi ${result.succeededIds.length} chứng chỉ.',
          type: ToastType.success,
        );
      } else {
        AppToast.show(
          context,
          message:
              'Thu hồi thành công ${result.succeededIds.length}/${result.totalRequested} mục (${result.failedReasons.length} mục lỗi).',
          type: ToastType.error,
        );
      }
    } on AppFailure catch (failure) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: failure.userMessage,
        type: ToastType.error,
      );
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return 'Vô thời hạn';
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d/$m/${dt.year}';
  }

  Widget _buildStatusBadge(CertificateStatus status) {
    final (label, fg, bg) = switch (status) {
      CertificateStatus.valid => (
          'Còn hiệu lực',
          AppColors.success,
          AppColors.successBg,
        ),
      CertificateStatus.expired => (
          'Hết hạn',
          AppColors.warning,
          AppColors.warningBg,
        ),
      CertificateStatus.revoked => (
          'Đã thu hồi',
          AppColors.error,
          AppColors.errorBg,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.xxs),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.smallMedium.copyWith(color: fg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final certAsync = ref.watch(certificateListNotifierProvider);
    final selectedIds = ref.watch(selectedCertificateIdsProvider);

    final columns = <AppTableColumn<Certificate>>[
      AppTableColumn<Certificate>(
        title: 'MÃ CHỨNG CHỈ',
        width: 155,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.certificateCode,
      ),
      AppTableColumn<Certificate>(
        title: 'MÃ SV',
        width: 115,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.studentCode,
      ),
      AppTableColumn<Certificate>(
        title: 'SINH VIÊN',
        width: 185,
        valueGetter: (c) => c.studentName, // Inter + Truncation + Tooltip
      ),
      AppTableColumn<Certificate>(
        title: 'TÊN CHỨNG CHỈ',
        width: 260,
        valueGetter: (c) => c.title, // Inter + Truncation + Tooltip
      ),
      AppTableColumn<Certificate>(
        title: 'ĐƠN VỊ CẤP',
        width: 200,
        valueGetter: (c) => c.issuer,
      ),
      AppTableColumn<Certificate>(
        title: 'ĐIỂM',
        width: 95,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => c.score.toStringAsFixed(2),
      ),
      AppTableColumn<Certificate>(
        title: 'NGÀY CẤP',
        width: 120,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => _formatDate(c.issuedAt),
      ),
      AppTableColumn<Certificate>(
        title: 'HẾT HẠN',
        width: 120,
        isNumeric: true, // JetBrains Mono + tabular-nums
        valueGetter: (c) => _formatDate(c.expiredAt),
      ),
      AppTableColumn<Certificate>(
        title: 'TRẠNG THÁI',
        width: 130,
        valueGetter: (c) => c.status.name,
        customCellBuilder: (c) => _buildStatusBadge(c.status),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Danh sách Chứng chỉ',
                      style: AppTypography.headingLarge,
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Theo dõi văn bằng, chứng chỉ ngoại ngữ và tin học theo từng mã sinh viên',
                      style: AppTypography.small,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 280,
                child: ShakeWidget(
                  controller: _searchShakeCtrl,
                  child: TextField(
                    controller: _searchCtrl,
                    onSubmitted: _submitSearch,
                    style: AppTypography.body,
                    decoration: const InputDecoration(
                      hintText: 'Tìm mã chứng chỉ, mã SV, tên...',
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppScaleButton(
                label: 'Thêm chứng chỉ',
                icon: Icons.add,
                onPressed: () {
                  AppToast.show(
                    context,
                    message: 'Mở biểu mẫu cấp mới chứng chỉ.',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // BẮT BUỘC đủ 4 trạng thái DoD: Loading (Skeleton), Empty, Error, Happy Path
          Expanded(
            child: DoDStateBuilder<List<Certificate>>(
              asyncValue: certAsync,
              isEmpty: (items) => items.isEmpty,
              loadingSkeleton: const AppDataTableSkeleton(
                rowCount: 8,
                columnCount: 8,
              ),
              emptyIcon: Icons.workspace_premium_outlined,
              emptyTitle: 'Chưa có chứng chỉ nào được ghi nhận',
              emptySubtitle:
                  'Không có chứng chỉ nào khớp với điều kiện hiện tại. Hãy thêm chứng chỉ mới hoặc đặt lại bộ lọc.',
              emptyCtaLabel: 'Thêm chứng chỉ mới',
              onEmptyCtaPressed: () {
                _searchCtrl.clear();
                ref.read(certificateSearchProvider.notifier).state = '';
              },
              onRetry: () {
                ref.read(certificateListNotifierProvider.notifier).refresh();
              },
              dataBuilder: (items) => AppDataTable<Certificate>(
                items: items,
                idGetter: (c) => c.id,
                columns: columns,
                selectedIds: selectedIds,
                onSelectionChanged: (updated) {
                  ref.read(selectedCertificateIdsProvider.notifier).state =
                      updated;
                },
                bulkActionsBuilder: (ids) => [
                  AppScaleButton(
                    label: 'Thu hồi (${ids.length})',
                    icon: Icons.block_outlined,
                    isOutlined: true,
                    isDestructive: true,
                    onPressed: () => _handleBulkRevoke(ids),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

### 4.5. Tự động kiểm tra chất lượng PR (`.github/workflows/ci.yml` & `.github/PULL_REQUEST_TEMPLATE.md`)

```yaml
# .github/workflows/ci.yml
name: Flutter CI & Contract Check

on:
  pull_request:
    branches: [ main, develop ]

jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          cache: true
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - name: Verify clean codegen (no uncommitted freezed/g.dart diffs)
        run: git diff --exit-code -- '*.freezed.dart' '*.g.dart'
      - run: dart analyze --fatal-infos
      - run: flutter test
```

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->
## Tóm tắt thay đổi
- Feature / Scope:

## Checklist Definition of Done (Bắt buộc)
- [ ] **Kiến trúc**: UI chỉ gọi `abstract class Repository` qua Riverpod, không import Firebase SDK trong `presentation/`.
- [ ] **Model**: Toàn bộ entity/DTO dùng `freezed` + `json_serializable` và đã chạy `build_runner`.
- [ ] **Data Table**: Đủ Sticky Header, Text Truncation (`...` + Tooltip), Bulk Actions Checkbox.
- [ ] **Typography**: `Inter` cho text, `JetBrains Mono` + `tabular-nums` cho mọi cột số (GPA, tuổi, mã SV, điểm, ngày).
- [ ] **Micro-interactions**: Animation 150ms–250ms, nút scale 0.95/Ripple, Shake 150ms khi lỗi form, Toast tự ẩn sau 3s.
- [ ] **4 Trạng thái DoD**:
  - [ ] Loading State dùng Skeleton (cấm dùng Spinner).
  - [ ] Empty State có icon minh họa và nút CTA.
  - [ ] Error State báo lỗi mạng/DB kèm nút "Thử lại".
  - [ ] Happy Path hiển thị đúng dữ liệu chuẩn.
```

## 5. Phân tích Rủi ro (Edge Cases) & Cơ chế Phòng ngừa trong Code

| # | Rủi ro (Edge Case) | Hậu quả nếu không phòng ngừa | Cơ chế phòng ngừa đã cài đặt trong Code |
| :--- | :--- | :--- | :--- |
| **1** | **Lệch hợp đồng (Contract Drift) & nghẽn tiến độ giữa A và B** | Dev A phải dừng việc chờ Dev B làm xong Firestore, hoặc B đổi tên trường làm gãy toàn bộ UI của A khi merge. | Khóa cứng `abstract class Repository` và `freezed` entities ở tầng `domain/`, kết hợp `FakeCertificateRepository` và `repository_providers.dart`. A code và test đủ 4 trạng thái DoD độc lập; khi B xong Firebase chỉ cần đổi đúng 1 dòng trong provider DI. |
| **2** | **Xung đột Git (Merge Conflict) trên file sinh tự động `*.freezed.dart` / `*.g.dart`** | Hai người cùng sửa model khiến file generated xung đột hàng trăm dòng, sửa tay dễ làm hỏng hàm `fromJson`. | Quy định tách riêng nhánh `chore/contract-*` để chốt model trước, và bước CI `git diff --exit-code -- '*.freezed.dart' '*.g.dart'` tự động chặn PR nếu quên chạy `build_runner`. |
| **3** | **Rò rỉ `FirebaseException` lên tầng Presentation** | Màn hình Error State hiện chuỗi lỗi thô tiếng Anh của Firebase (`[cloud_firestore/permission-denied] ...`), vi phạm Clean Architecture và trải nghiệm người dùng. | Định nghĩa `sealed class AppFailure` (Freezed) ở `lib/core/errors/app_failure.dart`. Tầng Data của B bắt buộc map mọi ngoại lệ sang `AppFailure`, tầng UI của A chỉ đọc `failure.userMessage`. |
| **4** | **Lỗi một phần (Partial Failure) khi chạy Bulk Actions** | Người dùng chọn thu hồi/xóa 10 chứng chỉ nhưng có 2 bản ghi đã bị quản trị viên khác xóa trước đó; nếu hàm trả về `void` sẽ không thể báo chính xác số lượng thành công/thất bại. | Mọi hàm Bulk trong `UserRepository`, `StudentRepository`, `CertificateRepository` đều trả về `BulkActionResult` gồm `succeededIds` và `failedReasons` để Toast hiển thị chính xác tỷ lệ thành công/lỗi. |
| **5** | **Race Condition khi tìm kiếm / lọc nhanh liên tiếp** | Người dùng gõ từ khóa A (mạng chậm 2 giây), ngay sau đó gõ từ khóa B (trả về sau 300ms); kết quả của A về sau ghi đè lên kết quả của B. | Trong `CertificateListNotifier.build()`, gắn bộ đếm `_requestVersion`; nếu `version != _requestVersion` khi `await` hoàn tất thì bỏ qua kết quả cũ, không ghi đè UI. |
| **6** | **Ngày hết hạn `null` hoặc số điểm chênh lệch chữ số làm nhảy cột bảng** | Chứng chỉ không có ngày hết hạn gây `NullPointerException`, hoặc điểm `7.5` và `940.00` không thẳng hàng cột dọc. | Khai báo `DateTime? expiredAt` trong `Certificate`, chuẩn hóa hiển thị `'Vô thời hạn'`, định dạng điểm cố định `toStringAsFixed(2)` và gắn `isNumeric: true` để tự động áp dụng `JetBrains Mono` + `tabular-nums`. |
