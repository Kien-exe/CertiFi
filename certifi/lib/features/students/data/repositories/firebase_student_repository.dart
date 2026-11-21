// lib/features/students/data/repositories/firebase_student_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/app_failure.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

class FirebaseStudentRepository implements StudentRepository {
  final FirebaseFirestore _firestore;

  const FirebaseStudentRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('students');

  Student _docToStudent(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Student.fromJson({
      ...data,
      'id': doc.id,
      'enrolledAt': (data['enrolledAt'] is Timestamp)
          ? (data['enrolledAt'] as Timestamp).toDate().toIso8601String()
          : data['enrolledAt'] as String,
      'updatedAt': data['updatedAt'] is Timestamp
          ? (data['updatedAt'] as Timestamp).toDate().toIso8601String()
          : data['updatedAt'],
      'archivedAt': data['archivedAt'] is Timestamp
          ? (data['archivedAt'] as Timestamp).toDate().toIso8601String()
          : data['archivedAt'],
    });
  }

  Map<String, dynamic> _toJson(Student s) {
    final json = s.toJson()..remove('id');
    return json;
  }

  @override
  Future<List<Student>> getStudents({
    String? searchQuery,
    String? majorFilter,
    double? minGpa,
  }) async {
    final snapshot = await _collection.get();

    var students = snapshot.docs
        .map(_docToStudent)
        // Soft delete: ẩn các bản ghi đã lưu trữ khỏi danh sách thường
        .where((s) => s.archivedAt == null)
        .toList();

    if (majorFilter != null && majorFilter.isNotEmpty) {
      students = students.where((s) => s.major == majorFilter).toList();
    }
    if (minGpa != null) {
      students = students.where((s) => s.gpa >= minGpa).toList();
    }
    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.trim().toLowerCase();
      students = students.where((s) {
        return s.studentCode.toLowerCase().contains(q) ||
            s.fullName.toLowerCase().contains(q) ||
            s.email.toLowerCase().contains(q) ||
            s.major.toLowerCase().contains(q);
      }).toList();
    }

    students.sort((a, b) => a.studentCode.compareTo(b.studentCode));
    return students;
  }

  @override
  Future<Student> getStudentById(String studentId) async {
    final doc = await _collection.doc(studentId).get();
    if (!doc.exists || doc.data() == null) {
      throw AppFailure.notFound(entityName: 'sinh viên', entityId: studentId);
    }
    return _docToStudent(doc);
  }

  @override
  Future<Student> createStudent(Student student) async {
    try {
      final docRef = await _collection.add(_toJson(student));
      return student.copyWith(id: docRef.id);
    } catch (e) {
      throw AppFailure.unknown(
        message: 'Không thể tạo hồ sơ sinh viên.',
        rawError: e,
      );
    }
  }

  @override
  Future<Student> updateStudent(Student student) async {
    try {
      final updated = student.copyWith(updatedAt: DateTime.now());
      await _collection.doc(student.id).set(
            _toJson(updated),
            SetOptions(merge: true),
          );
      return updated;
    } catch (e) {
      throw AppFailure.unknown(
        message: 'Không thể cập nhật hồ sơ sinh viên.',
        rawError: e,
      );
    }
  }

  @override
  Future<BulkActionResult> deleteStudentsBulk(Set<String> studentIds) async {
    final succeeded = <String>[];
    final failed = <String, String>{};

    // Soft delete: chỉ gắn archivedAt, không xóa vật lý (giữ lịch sử)
    for (final id in studentIds) {
      try {
        await _collection.doc(id).update({
          'archivedAt': FieldValue.serverTimestamp(),
        });
        succeeded.add(id);
      } catch (e) {
        failed[id] = e.toString();
      }
    }

    return BulkActionResult(
      totalRequested: studentIds.length,
      succeededIds: succeeded,
      failedReasons: failed,
    );
  }
}
