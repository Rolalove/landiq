import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landiq/features/assessment/data/assessment_model.dart';
import 'package:landiq/features/assessment/data/assessment_repository.dart';

final assessmentRepositoryProvider = Provider<AssessmentRepository>((ref) {
  return AssessmentRepository();
});

// Saved assessments list
final assessmentsListProvider = FutureProvider<List<Assessment>>((ref) async {
  final repo = ref.watch(assessmentRepositoryProvider);
  return repo.getAssessments();
});

// Currently viewed assessment
final currentAssessmentProvider = StateProvider<Assessment?>((ref) => null);

// Create assessment notifier
final createAssessmentProvider =
    StateNotifierProvider<CreateAssessmentNotifier, AsyncValue<Assessment?>>(
        (ref) {
  return CreateAssessmentNotifier(ref.watch(assessmentRepositoryProvider));
});

class CreateAssessmentNotifier extends StateNotifier<AsyncValue<Assessment?>> {
  final AssessmentRepository _repo;

  CreateAssessmentNotifier(this._repo)
      : super(const AsyncValue.data(null));

  Future<Assessment?> create({
    required double latitude,
    required double longitude,
    required double areaHectares,
  }) async {
    state = const AsyncValue.loading();
    try {
      final assessment = await _repo.createAssessment(
        latitude: latitude,
        longitude: longitude,
        areaHectares: areaHectares,
      );
      state = AsyncValue.data(assessment);
      return assessment;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return null;
    }
  }

  Future<bool> save(String id) async {
    try {
      await _repo.saveAssessment(id);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _repo.deleteAssessment(id);
      return true;
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
