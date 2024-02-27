import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/models/document_model.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final fetchDocsProvider = StreamProvider((ref) => ref.read(fetchServicesProvider).getAllDocs());

final fetchServicesProvider = Provider((ref) {
  return FetchServices(ref: ref);
});
class FetchServices extends StateNotifier<bool> {
  final Ref _ref;
  FetchServices({
    required Ref ref,
  })  : _ref = ref,
        super(false);
  Stream<List<Doc>> getAllDocs() {
    return _ref.read(firestoreProvider).collection("documents").snapshots().map(
        (event) => event.docs
            .map((e) => Doc.fromMap(e.data() as Map<String, dynamic>))
            .toList());
  }
}
