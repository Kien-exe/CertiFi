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
