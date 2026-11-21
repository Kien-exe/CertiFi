// lib/features/students/presentation/providers/student_providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/bulk_action_result.dart';
import '../../data/repositories/firebase_student_repository.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';

/// Inject interface StudentRepository (UI không biết tới FirebaseFirestore)
final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return FirebaseStudentRepository(FirebaseFirestore.instance);
});

final studentSearchQueryProvider = StateProvider<String>((ref) => '');
final studentMajorFilterProvider = StateProvider<String?>((ref) => null);
final studentMinGpaProvider = StateProvider<double?>((ref) => null);

final selectedStudentIdsProvider = StateProvider<Set<String>>((ref) => {});

final studentListNotifierProvider =
    AsyncNotifierProvider<StudentListNotifier, List<Student>>(
  StudentListNotifier.new,
);

class StudentListNotifier extends AsyncNotifier<List<Student>> {
  @override
  Future<List<Student>> build() async {
    final query = ref.watch(studentSearchQueryProvider);
    final major = ref.watch(studentMajorFilterProvider);
    final minGpa = ref.watch(studentMinGpaProvider);
    final repo = ref.watch(studentRepositoryProvider);
    final items = await repo.getStudents(
      searchQuery: query,
      majorFilter: major,
      minGpa: minGpa,
    );

    // Tự động loại bỏ các ID đã chọn nhưng không còn tồn tại trong danh sách hiện tại
    final validIds = items.map((e) => e.id).toSet();
    final currentSelected = ref.read(selectedStudentIdsProvider);
    final sanitized = currentSelected.intersection(validIds);
    if (sanitized.length != currentSelected.length) {
      Future.microtask(() {
        ref.read(selectedStudentIdsProvider.notifier).state = sanitized;
      });
    }

    return items;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final query = ref.read(studentSearchQueryProvider);
      final major = ref.read(studentMajorFilterProvider);
      final minGpa = ref.read(studentMinGpaProvider);
      return ref.read(studentRepositoryProvider).getStudents(
            searchQuery: query,
            majorFilter: major,
            minGpa: minGpa,
          );
    });
  }

  Future<Student> createStudent(Student student) async {
    final created = await ref.read(studentRepositoryProvider).createStudent(student);
    await refresh();
    return created;
  }

  Future<Student> updateStudent(Student student) async {
    final updated = await ref.read(studentRepositoryProvider).updateStudent(student);
    await refresh();
    return updated;
  }

  Future<BulkActionResult> deleteSelected(Set<String> ids) async {
    final result = await ref.read(studentRepositoryProvider).deleteStudentsBulk(ids);
    ref.read(selectedStudentIdsProvider.notifier).state = {};
    await refresh();
    return result;
  }
}
