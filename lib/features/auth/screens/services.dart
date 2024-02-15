import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Services {
  String uri = "http://192.168.0.103:4000";
  // String  uri = "http://localhost:3000";
  Future contactServer(BuildContext context,String link) async {
    
    try {
      // String link =
      //   "C:/Users/Vighnesh/Flutter/Projects/ml_project/assets/demo.pdf";
      http.Response res = await http.post(
        Uri.parse('$uri/demo'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "link":link,
        }),
      );
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
          // print(stringData);
          // print(res.body);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Success")));
        },
      );
      return stringData;
    } catch (e) {
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
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['msg'])));
        break;
      case 500:
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonDecode(response.body)['error'])));
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
