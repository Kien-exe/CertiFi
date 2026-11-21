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
