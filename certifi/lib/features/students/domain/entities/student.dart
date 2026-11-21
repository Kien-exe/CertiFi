// lib/features/students/domain/entities/student.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'student.freezed.dart';
part 'student.g.dart';

enum StudentStatus { active, inactive }

@freezed
abstract class Student with _$Student {
  const factory Student({
    required String id,
    required String studentCode,
    required String fullName,
    required String email,
    required String major,
    required int age,
    required double gpa,
    required DateTime enrolledAt,
    @Default(StudentStatus.active) StudentStatus status,
    DateTime? updatedAt,
    // Soft delete: khi xóa chỉ set archivedAt, giữ lịch sử tra cứu
    DateTime? archivedAt,
  }) = _Student;

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
}
