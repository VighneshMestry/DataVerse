import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ml_project/models/document_model.dart';

class MyClassroomServices {
  CollectionReference get _docs =>
      FirebaseFirestore.instance.collection("documents");

  Stream<List<Doc>> getMySubjectDocuments(String userId, String type) {
    return _docs
        .where('userId', isEqualTo: userId)
        .where('type', isEqualTo: type)
        .snapshots()
        .map(
          (event) => event.docs
              .map((e) => Doc.fromMap(e.data() as Map<String, dynamic>))
              .toList(),
        );
  }
}
