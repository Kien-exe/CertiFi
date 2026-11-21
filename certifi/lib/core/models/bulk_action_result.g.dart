// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_action_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BulkActionResult _$BulkActionResultFromJson(Map<String, dynamic> json) =>
    _BulkActionResult(
      totalRequested: (json['totalRequested'] as num).toInt(),
      succeededIds: (json['succeededIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      failedReasons: Map<String, String>.from(json['failedReasons'] as Map),
    );

Map<String, dynamic> _$BulkActionResultToJson(_BulkActionResult instance) =>
    <String, dynamic>{
      'totalRequested': instance.totalRequested,
      'succeededIds': instance.succeededIds,
      'failedReasons': instance.failedReasons,
    };
