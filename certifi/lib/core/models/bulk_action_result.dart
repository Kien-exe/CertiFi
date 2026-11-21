// lib/core/models/bulk_action_result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bulk_action_result.freezed.dart';
part 'bulk_action_result.g.dart';

/// Kết quả trả về cho mọi thao tác Bulk Actions (Xóa hàng loạt / Cập nhật hàng loạt)
@freezed
abstract class BulkActionResult with _$BulkActionResult {
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
