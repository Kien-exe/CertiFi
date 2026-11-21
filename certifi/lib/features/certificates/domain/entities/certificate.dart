// lib/features/certificates/domain/entities/certificate.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'certificate.freezed.dart';
part 'certificate.g.dart';

enum CertificateStatus { valid, expired, revoked }

@freezed
abstract class Certificate with _$Certificate {
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
