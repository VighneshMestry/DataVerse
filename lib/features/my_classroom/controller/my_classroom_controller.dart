import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/my_classroom/repository/my_classroom_services.dart';
import 'package:ml_project/models/document_model.dart';

final myClassroomControllerProvider =
    StateNotifierProvider<MyClassroomController, bool>((ref) {
  final myClassroomServicesRepository = ref.read(myClassroomServicesProvider);
  return MyClassroomController(ref: ref, myClassroomServices: myClassroomServicesRepository);
});

 final getMySubjectDocumentsProvider =
      StreamProvider.family((ref, String type) {
    return ref
        .watch(myClassroomControllerProvider.notifier)
        .getMySubjectDocuments(type);
  });

   final getClassroomDocumentsProvider =
      StreamProvider.family((ref, String subjectJoiningCode) {
    return ref
        .watch(myClassroomControllerProvider.notifier)
        .getClassroomDocuments(subjectJoiningCode);
  });

  // final getUserDocumentsProvider = StreamProvider.family((ref, String userId) {
  //   return ref.watch(myClassroomControllerProvider).getUserDocuments(userId);
  // });

  // final getDocumentsByPredictionProvider =
  //     StreamProvider.family((ref, List<Doc> documents) {
  //   return;
  // });

class MyClassroomController extends StateNotifier<bool> {
  final Ref _ref;
  final MyClassroomServices _myClassroomServices;
  MyClassroomController({required Ref ref, required MyClassroomServices myClassroomServices}) : _ref = ref, _myClassroomServices = myClassroomServices, super(false);

  Stream<List<Doc>> getMySubjectDocuments(String prediction) {
    return _myClassroomServices.getMySubjectDocuments(_ref.read(userProvider)!.uid, prediction);
  }

  Stream<List<Doc>> getClassroomDocuments(String subjectJoiningCode) {
    return _myClassroomServices.getClassroomDocuments(subjectJoiningCode);
  }
 
}
