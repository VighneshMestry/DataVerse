import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services {
  String uri = "http://192.168.0.103:4000";
  // String  uri = "http://localhost:3000";


  Future<void> uploadPDF(BuildContext context, File? _pdfFile, String name) async {
    if (_pdfFile != null) {
      try {
        Reference storageReference = FirebaseStorage.instance.ref().child('pdfs/$name');
        UploadTask uploadTask = storageReference.putFile(_pdfFile);
        await uploadTask.whenComplete(() => print('File Uploaded'));
      } catch (e) {
        print('Error uploading PDF: $e');
        ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      print('No PDF file selected');
    }
  }

  Future<String> getPdfDownloadUrl(String name) async {
  String downloadUrl = '';
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child('pdfs/$name');
    downloadUrl = await storageReference.getDownloadURL();
  } catch (e) {
    print('Error getting download URL: $e');
  }
  return downloadUrl;
}



  Future contactServer(BuildContext context,String link) async {
    
    try {
      // String link =
      //   "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf";
      print("Dart api run");
      http.Response res = await http.post(
        Uri.parse('$uri/demo'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "link":link,
        }),
      );
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
          print("STring data from dart api call&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $stringData");
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

  Future contactServerForText(BuildContext context,String link) async {
    
    try {
      // String link =
      //   "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf";
      print("Dart api run");
      http.Response res = await http.post(
        Uri.parse('$uri/demoGet'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "link":link,
        }),
      );
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
          print("STring data from dart api call&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& $stringData");
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
        { print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['msg'])));}
        break;
      case 500:
        { print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['error'])));}
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
