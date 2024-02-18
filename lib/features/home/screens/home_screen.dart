import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ml_project/features/auth/screens/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> files = [];
  List<String> fileNames = [];
  Future<List<File>> pickFile(BuildContext context) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      fileNames = result.names.map((name) => name!).toList();
      files = result.paths.map((path) => File(path!)).toList();
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Upload Cancel")));
    }
    return files;
  }

  void callPickFiles() async {
    Services services = Services();
    await pickFile(context);
    for (int i = 0; i < files.length; i++) {
      await services.uploadPDF(context, files[i], fileNames[i]);
      String singleFilePath = await services.getPdfDownloadUrl(fileNames[i]);
      print("{{{{{{{{{{{{{{{{{{{{{$singleFilePath}}}}}}}}}}}}}}}}}}}}}");
      await readFileContent(singleFilePath).then((content) {
        print("String data from dart function call000000000000000000000000000000000000000 $content");
        fileContent.add(content);
        predictions = predict(content);
        setState(() {});
      }).catchError((error) {
        print("Here Error in homeScreen${error.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())));
      });
      
    }
  }

  Future<String> readFileContent(String path) async {
    Services services = Services();
    return await services.contactServer(context, path);
  }

  dynamic _model;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    // Load the serialized model from assets
    final String modelData = await rootBundle
        .loadString('assets/multinomial_naive_bayes_model.json');

    // Parse the JSON data
    final Map<String, dynamic> modelMap = json.decode(modelData);
    _model = modelMap;
  }

  int predict(String inputText) {
    if (_model == null ||
        !_model.containsKey('vocabulary') ||
        !_model.containsKey('class_prior') ||
        !_model.containsKey('feature_count')) {
      return -1; // Return an error code or handle the error appropriately
    }

    final vocabulary = _model['vocabulary'];
    final classPrior = _model['class_prior'];
    // final featureCount = _model['feature_count'];
    // final classCount = _model['class_count'];

    // Tokenize the input text using the same CountVectorizer vocabulary
    final List<String> tokens = inputText.toLowerCase().split(RegExp(r'\W+'));

    // Initialize variables to store probabilities for each class
    final List<double> classProbabilities = List.filled(classPrior.length, 0.0);

    // Calculate log probabilities for each class
    for (int i = 0; i < classPrior.length; i++) {
      double logProbability = _model['class_prior'][i];

      for (String token in tokens) {
        if (vocabulary.containsKey(token)) {
          final tokenIndex = _model['vocabulary'][token];
          logProbability += _model['feature_count'][i][tokenIndex];
        }
      }

      classProbabilities[i] = logProbability;
    }

    // Select the class with the highest probability
    int predictedClass = 0;
    double maxProbability = classProbabilities[0];

    for (int i = 1; i < classProbabilities.length; i++) {
      if (classProbabilities[i] > maxProbability) {
        maxProbability = classProbabilities[i];
        predictedClass = i;
      }
    }
    return predictedClass;
  }

  int predictions = -1;
  List<String> fileContent = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  callPickFiles();
                },
                child: const Text("Upload"),
              ),
              ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: files.length,
                itemBuilder: (context, index) {
                  return Text(files[index].path);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  predictions = predict("mining"); //1
                  setState(() {});
                  print(
                      "_________________________++++++++++++++++++++++++++++++++++++++++");
                  print(predictions);
                },
                child: const Text("Predict"),
              ),
              Text("$predictions"),
              ListView.builder(
                // scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: fileContent.length,
                itemBuilder: (context, index) {
                  return Text("file content ^^^^^^^^^^^^^^^^^^^^^^${fileContent[index]}");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
