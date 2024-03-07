import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/models/document_model.dart';



final myClassroomServicesProvider = Provider((ref) {
  return MyClassroomServices();
});

class MyClassroomServices {
  CollectionReference get _docs =>
      FirebaseFirestore.instance.collection("documents");

  Stream<List<Doc>> getMySubjectDocuments(String userId, String prediction) {
    // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    try {
      return _docs.where('userId', isEqualTo: userId).snapshots().map(
        (event) {
          // print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
          List<Doc> documents = [];
          for (var docs in event.docs) {
            // print(
            //     "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
            // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
            Doc doc = Doc.fromMap(docs.data() as Map<String, dynamic>);
            print(doc.fileName);
            if (doc.prediction == prediction) {
              documents.add(Doc.fromMap(docs.data() as Map<String, dynamic>));
            }
          }
          print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
          for (int i = 0; i < documents.length; i++) {
            print(documents[i].fileName);
          }
          return documents;
        },
      );
    } on FirebaseException catch(e) {
      print(e.toString());
      throw e;
    } 
    catch (e) {
      print("ERror !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Doc>> getUserDocuments(String userId) {
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    try {
      return _docs
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map(
        (event) {
          print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
          List<Doc> documents = [];
          for (var docs in event.docs) {
            print(
                "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
            // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
            print(Doc.fromMap(docs.data() as Map<String, dynamic>));
            Doc doc = Doc.fromMap(docs.data() as Map<String, dynamic>);
            documents.add(doc);
          }
          print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
          return documents;
        },
      );
    } catch (e) {
      print("ERror !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${e.toString()}");
      throw e.toString();
    }
  }

  Stream<List<Doc>> getDocumentsByPrediction(List<Doc> documents, String prediction) {
    print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    try {
      return _docs
          .where('prediction', isEqualTo: prediction, whereIn: documents.map((e) => e.fileName))
          .snapshots()
          .map(
        (event) {
          print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
          List<Doc> documents = [];
          for (var docs in event.docs) {
            print(
                "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
            // Here ths "event" received is in QuerySnapshot<Object> format so the event is converted to Community model by converting the event to community model and adding to the list
            print(Doc.fromMap(docs.data() as Map<String, dynamic>));
            Doc doc = Doc.fromMap(docs.data() as Map<String, dynamic>);
            documents.add(doc);
          }
          print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
          return documents;
        },
      );
    } catch (e) {
      print("ERror !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!${e.toString()}");
      throw e.toString();
    }
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
