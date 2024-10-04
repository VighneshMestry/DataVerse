import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ml_project/models/ai_document_model.dart';
import 'package:ml_project/models/document_model.dart';

final servicesProvider = StateNotifierProvider<Services, bool>((ref) {
  return Services();
});

// final contactServerProvider = Provider((ref) {
//   return ;
// });

class Services extends StateNotifier<bool> {
    String uri = "https://dataverse-x6cs.onrender.com";
  // String uri = "http://192.168.0.100:4000";
  // String  uri = "http://localhost:3000";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Services() : super(false);

  CollectionReference get _myDocs =>
      _firestore.collection("myDocuments");

  Future uploadToFirebase(Doc doc) async {
    return await _myDocs.doc(doc.docId).set(doc.toMap());
  }

  Future uploadAIDocToFirebase(AIDoc doc) async {
    return await _firestore.collection("AIDocuments").doc(doc.aiDocId).set(doc.toMap());
  }

  Future<void> updateDocWithAiField(Doc doc) async {
    return await _myDocs.doc(doc.docId).update(doc.toMap());
  }

  Future<void> uploadPDF(
      BuildContext context, File? pdfFile, String name) async {
    if (pdfFile != null) {
      try {
        Reference storageReference =
            FirebaseStorage.instance.ref().child('docs/$name');
        UploadTask uploadTask = storageReference.putFile(pdfFile);
        await uploadTask.whenComplete(() => print('File Uploaded'));
      } catch (e) {
        print('Error uploading PDF: $e');
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      print('No PDF file selected');
    }
  }

  Future<void> updateNameDescriptionTags(Doc doc) async {
    return await _myDocs.doc(doc.docId).update(doc.toMap());
  }

  Future<FilePickerResult?> pickFile(BuildContext context) {
    return FilePicker.platform.pickFiles(allowMultiple: true);
  }

  Future<String> getPdfDownloadUrl(String name) async {
    String downloadUrl = '';
    try {
      Reference storageReference =
          FirebaseStorage.instance.ref().child('docs/$name');
      downloadUrl = await storageReference.getDownloadURL();
    } catch (e) {
      print('Error getting download URL: $e');
    }
    return downloadUrl;
  }

  scanImages (ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if(file != null) {
      return file;
    }
  }

  Future contactServerForAiDoc(BuildContext context, String content) async {
    try {
      state = true;
      print("Dart api run");
      http.Response res = await http.post(
        Uri.parse('https://mood-lens-server.onrender.com/api/v1/notes/simplify_notes'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "notes": content,
        }),
      );
      state = false;
      print("Dart api finish");
      String stringData = "";
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Map<String, dynamic> data = json.decode(res.body);
        stringData = data['simplifiedNotes'];
          print(
              "STring data from dart api call&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $stringData");
          // print(res.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        },
      );
      return stringData;
    } catch (e) {
      print("Error in the services catch block");
      print(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future contactServer(BuildContext context, String link) async {
    try {
      state = true;
      // String link =
      //   "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf";
      print("Dart api run");
      http.Response res = await http.post(
        Uri.parse('$uri/demo'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "link": link,
        }),
      );
      state = false;
      print("Dart api finish");
      String stringData = "";
      // ignore: use_build_context_synchronously
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          Map<String, dynamic> jsonMap = jsonDecode(res.body);
          // Extract the data array from the "msg" object
          List<int> data = List<int>.from(jsonMap['msg']['data']);

          // Convert the data array to a string
          stringData = String.fromCharCodes(data);
          print(
              "STring data from dart api call&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $stringData");
          // print(res.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        },
      );
      return stringData;
    } catch (e) {
      print("Error in the services catch block");
      print(e.toString());
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void httpErrorHandle({
    required http.Response response,
    required BuildContext context,
    required VoidCallback onSuccess,
  }) {
    switch (response.statusCode) {
      case 200:
        onSuccess();
        break;
      case 400:
        {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonDecode(response.body)['msg'])));
        }
        break;
      case 500:
        {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonDecode(response.body)['error'])));
        }
        break;
      default:
        {
          print(response.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response.body)));
        }
    }
  }
}
