import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/classroom/repository/classroom_repository.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:ml_project/models/subject_model.dart';

final classroomControllerProvider =
    StateNotifierProvider<ClassroomController, bool>((ref) {
  return ClassroomController(
    classroomRepository: ref.watch(classroomRepositoryProvider),
    ref: ref,
  );
});

final getJoinedClassroomProvider = StreamProvider((ref) {
  return ref.watch(classroomControllerProvider.notifier).getJoinedClassroom();
});

class ClassroomController extends StateNotifier<bool> {
  final ClassroomRepository _classroomRepository;
  final Ref _ref;

  ClassroomController({
    required ClassroomRepository classroomRepository,
    required Ref ref,
  })  : _classroomRepository = classroomRepository,
        _ref = ref,
        super(false);

  void createNewSubject(Subject subject, BuildContext context) async {
    try {
      await _classroomRepository.createNewSubject(subject);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Created ${subject.name}")));
    } on Exception {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Subject with joining code ${subject.subjectJoiningCode} already exists."),
        ),
      );
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<List<Subject>> getJoinedClassroom() {
    String userId = _ref.watch(userProvider)!.uid;
    return _classroomRepository.getJoinedClassroom(userId);
  }

  void joinSubject(String subjectJoiningCode) {
    _ref.watch(classroomRepositoryProvider).joinSubject(subjectJoiningCode);
  }

  void uploadCustomDocument(Doc doc) {
    _ref.watch(classroomRepositoryProvider).uploadCustomDocument(doc);
  }
}
