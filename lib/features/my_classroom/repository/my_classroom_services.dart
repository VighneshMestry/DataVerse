import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/models/ai_document_model.dart';
import 'package:ml_project/models/document_model.dart';

final myClassroomServicesProvider = Provider((ref) {
  return MyClassroomServices();
});

class MyClassroomServices {
  CollectionReference get _myDocs =>
      FirebaseFirestore.instance.collection("myDocuments");
  CollectionReference get _docs =>
      FirebaseFirestore.instance.collection("documents");
  CollectionReference get _aiDocs =>
      FirebaseFirestore.instance.collection("AIDocuments");

  Future<AIDoc> getAiDocument(String mainDocId) async {
    QuerySnapshot snapshot =
        await _aiDocs.where("mainDocId", isEqualTo: mainDocId).get();
    return AIDoc.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
  }

  Stream<List<Doc>> getMySubjectDocuments(String userId, String prediction) {
    try {
      return _myDocs
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
        (event) {
          List<Doc> documents = [];
          for (var docs in event.docs) {
            // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
            Doc doc = Doc.fromMap(docs.data() as Map<String, dynamic>);
            if (doc.prediction == prediction) {
              documents.add(Doc.fromMap(docs.data() as Map<String, dynamic>));
            }
          }
          return documents;
        },
      );
    } on FirebaseException {
      rethrow;
    } catch (e) {
      print("ERror !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Doc>> getClassroomDocuments(String subjectJoiningCode) {
    try {
      return _docs
          .where('subjectJoiningCode', isEqualTo: subjectJoiningCode)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
        (event) {
          List<Doc> documents = [];
          for (var docs in event.docs) {
            // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
            print(Doc.fromMap(docs.data() as Map<String, dynamic>));
            Doc doc = Doc.fromMap(docs.data() as Map<String, dynamic>);
            documents.add(doc);
            print(doc.assignmentTitle);
            print("++++++++++++++++++++++++++++++++++++++++++++");
          }
          return documents;
        },
      );
    } catch (e) {
      print("ERror !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${e.toString()}");
      throw e.toString();
    }
  }
}
