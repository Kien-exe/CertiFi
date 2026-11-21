// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certificate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Certificate _$CertificateFromJson(Map<String, dynamic> json) => _Certificate(
  id: json['id'] as String,
  certificateCode: json['certificateCode'] as String,
  studentCode: json['studentCode'] as String,
  studentName: json['studentName'] as String,
  title: json['title'] as String,
  issuer: json['issuer'] as String,
  score: (json['score'] as num).toDouble(),
  status: $enumDecode(_$CertificateStatusEnumMap, json['status']),
  issuedAt: DateTime.parse(json['issuedAt'] as String),
  expiredAt: json['expiredAt'] == null
      ? null
      : DateTime.parse(json['expiredAt'] as String),
);

Map<String, dynamic> _$CertificateToJson(_Certificate instance) =>
    <String, dynamic>{
      'id': instance.id,
      'certificateCode': instance.certificateCode,
      'studentCode': instance.studentCode,
      'studentName': instance.studentName,
      'title': instance.title,
      'issuer': instance.issuer,
      'score': instance.score,
      'status': _$CertificateStatusEnumMap[instance.status]!,
      'issuedAt': instance.issuedAt.toIso8601String(),
      'expiredAt': instance.expiredAt?.toIso8601String(),
    };

const _$CertificateStatusEnumMap = {
  CertificateStatus.valid: 'valid',
  CertificateStatus.expired: 'expired',
  CertificateStatus.revoked: 'revoked',
};
