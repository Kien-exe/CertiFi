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
