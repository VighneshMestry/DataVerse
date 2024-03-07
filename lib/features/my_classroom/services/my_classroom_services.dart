import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/models/document_model.dart';

final getMySubjectDocumentsProvider = StreamProvider.family((ref, String type) {
  MyClassroomServices myClassroomServices = MyClassroomServices();
  String uid = ref.read(userProvider)!.uid;
  print(uid);
  print("UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
  return myClassroomServices.getMySubjectDocuments(uid, type);
});

class MyClassroomServices {
  CollectionReference get _docs =>
      FirebaseFirestore.instance.collection("documents");

  Stream<List<Doc>> getMySubjectDocuments(String userId, String type) {
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    return _docs
        .where('userId', isEqualTo: userId)
        .where('prediction', isEqualTo: type)
        .snapshots()
        .map((event) {
          print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
      List<Doc> documents = [];
      for (var docs in event.docs) {
        print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
        // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
        print(Doc.fromMap(docs.data() as Map<String, dynamic>));
        documents.add(Doc.fromMap(docs.data() as Map<String, dynamic>));
      }
      print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
      return documents;
    });
  }

  // Stream<List<Doc>> tempGetMySubjectDocuments(String userId, String type) {
  //   print(type + " !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
  //   return _docs.where('prediction', isEqualTo: type).snapshots().map(
  //       // (event) => event.docs
  //       //     .map((e) => Doc.fromMap(e.data() as Map<String, dynamic>))
  //       //     .toList(),
  //       (event) {
  //     List<Doc> documents = [];
  //     for (var docs in event.docs) {
  //       // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
  //       print(Doc.fromMap(docs.data() as Map<String, dynamic>));
  //       documents.add(Doc.fromMap(docs.data() as Map<String, dynamic>));
  //     }
  //     return documents;
  //   });
  // }
}
