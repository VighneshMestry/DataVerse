import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:ml_project/models/subject_model.dart';

final classroomRepositoryProvider = Provider((ref) {
  return ClassroomRepository(
      firebaseFirestore: FirebaseFirestore.instance, ref: ref);
});

class ClassroomRepository {
  final FirebaseFirestore _firebaseFirestore;
  final Ref _ref;

  ClassroomRepository({
    required FirebaseFirestore firebaseFirestore,
    required Ref ref,
  })  : _firebaseFirestore = firebaseFirestore,
        _ref = ref;

  CollectionReference get _subjects =>
      _firebaseFirestore.collection("subjects");

  CollectionReference get _docs =>
      _firebaseFirestore.collection("documents");

  String get userId => _ref.read(userProvider)!.uid;

  Future<void> createNewSubject(Subject subject) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection("subjects")
        .where('subjectJoiningCode', isEqualTo: subject.subjectJoiningCode)
        .get();

    // Check if a document with the same id already exists
    if (querySnapshot.docs.isNotEmpty) {
      throw Exception();
    } else {
      // Create a new subject document in Firestore
      await _firebaseFirestore
          .collection("subjects")
          .doc(subject.subjectJoiningCode)
          .set(subject.toMap());
    }
  }

  Stream<List<Subject>> getJoinedClassroom(String userId) {
    return _subjects
        .where("members", arrayContains: userId)
        .snapshots()
        .map((event) {
      List<Subject> subjects = [];
      for (var docs in event.docs) {
        // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
        subjects.add(Subject.fromMap(docs.data() as Map<String, dynamic>));
      }
      return subjects;
    });
  }

  Future<void> joinSubject(String subjectJoiningCode) async {
    String uid = _ref.watch(userProvider)!.uid;
    return await _subjects.doc(subjectJoiningCode).update({"members" : FieldValue.arrayUnion([uid])});
  }

  Future<void> uploadCustomDocument(Doc doc) async {
    return await _docs.doc(doc.docId).set(doc.toMap());
  }
  
  Future<FilePickerResult?> pickSingleFile(BuildContext context) {
    return FilePicker.platform.pickFiles(allowMultiple: false);
  }
}
