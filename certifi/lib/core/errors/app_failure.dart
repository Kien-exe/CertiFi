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
