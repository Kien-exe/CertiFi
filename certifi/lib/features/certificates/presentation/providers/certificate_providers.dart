// lib/features/certificates/presentation/providers/certificate_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../domain/entities/certificate.dart';

final certificateSearchProvider = StateProvider<String>((ref) => '');

/// Lọc theo mã sinh viên (VD: từ màn Student Detail). null = tất cả.
final certificateStudentCodeProvider = StateProvider<String?>((ref) => null);

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
    final studentCode = ref.watch(certificateStudentCodeProvider);
    final repo = ref.watch(certificateRepositoryProvider);

    final items = await repo.getCertificates(
      searchQuery: query,
      studentCode: studentCode,
    );

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
      final studentCode = ref.read(certificateStudentCodeProvider);
      return ref.read(certificateRepositoryProvider).getCertificates(
            searchQuery: query,
            studentCode: studentCode,
          );
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
