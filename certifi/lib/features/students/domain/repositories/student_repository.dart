// lib/features/students/domain/repositories/student_repository.dart
import '../../../../core/models/bulk_action_result.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents({
    String? searchQuery,
    String? majorFilter,
    double? minGpa,
  });

  Future<Student> getStudentById(String studentId);
  Future<Student> createStudent(Student student);
  Future<Student> updateStudent(Student student);
  Future<BulkActionResult> deleteStudentsBulk(Set<String> studentIds);
}
