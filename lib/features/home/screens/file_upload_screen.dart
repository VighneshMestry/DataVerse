import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ml_project/constants/constants.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/repository/services.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:uuid/uuid.dart';

class FileUploadScreen extends ConsumerStatefulWidget {
  const FileUploadScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FileUploadScreenState();
}

class _FileUploadScreenState extends ConsumerState<FileUploadScreen> {
  List<File> files = [];
  List<String> fileNames = [];
  List<String> downloadUrls = [];
  List<Doc> allDocuments = [];
  int predictions = -1;
  List<String> fileContent = [];
  bool success = false;
  int progress = 0;
  int totalProgress = 0;
  bool processFinish = false;

  void callPickFiles() async {
    final result = await ref.read(servicesProvider.notifier).pickFile(context);
    files = result!.paths.map((path) => File(path!)).toList();
    fileNames += result.names.map((name) => name!).toList();
    totalProgress = files.length;
    for (int i = 0; i < files.length; i++) {
      if (!context.mounted) {
        return;
      } else {
        await ref
            .read(servicesProvider.notifier)
            .uploadPDF(context, files[i], fileNames[i]);

        String singleFilePath = await ref
            .read(servicesProvider.notifier)
            .getPdfDownloadUrl(fileNames[i]);
        if (!context.mounted) return;
        await ref
            .read(servicesProvider.notifier)
            .contactServer(context, singleFilePath)
            .then((content) async {
          downloadUrls.add(singleFilePath);
          fileContent.add(content);
          predictions = predict(content);
          print(
              "$predictions PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
          final docId = const Uuid().v1();
          final document = Doc(
              fileName: fileNames[i],
              assignmentTitle: "New Assignment",
              assigmentDescription: "",
              userId: ref.read(userProvider)!.uid,
              docId: docId,
              subjectJoiningCode: "",
              type: "pdf",
              fileUrl: singleFilePath,
              prediction: Constants.subjectTypes[predictions],
              createdAt:
                  "${DateFormat("dd-MM-yyyy").format(DateTime.now())} ${TimeOfDay.now()}",
              tags: []);
          allDocuments.add(document);
          await ref.read(servicesProvider.notifier).uploadToFirebase(document);
          setState(() {
            success = true;
            progress = i + 1;
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        });
      }
    }
    setState(() {
      processFinish = true;
    });
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

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(servicesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Files"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade400),
                  height: 1,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    callPickFiles();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade50,
                  ),
                  child: const Text(
                    "Upload files",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              (fileNames.isEmpty)
                  ? const SizedBox()
                  : (isLoading)
                      ? const CircularProgressIndicator()
                      : ListView.builder(
                          // scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: fileNames.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Container(
                                height: 70,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Text(fileNames[index]),
                                    (processFinish)
                                        ? Text(
                                            "File Uploaded to ${allDocuments[index].prediction}")
                                        : const Text("File is being uploaded"),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              const SizedBox(height: 5),
              success
                  ? Center(
                      child: Text(
                        " $progress/$totalProgress Files Uploaded successfully!",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    )
                  : const SizedBox(),
              // ListView.builder(
              //   // scrollDirection: Axis.vertical,
              //   physics: const NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   itemCount: fileContent.length,
              //   itemBuilder: (context, index) {
              //     return Text(fileContent[index]);
              //   },
              // ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Uploading the files...",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    SizedBox(height: 15),
                    Text("* Any file format can be uploaded (.pdf, .docx, .pptx, .xlsx, .jpg, .png)",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                        "* The uploading can take upto few seconds if the network connection is slow.",
                        style: TextStyle(fontSize: 16)),
                    SizedBox(height: 10),
                    Text(
                        "If you have trouble uploading the documents,",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                            Text(
                        "Contact us",
                        style:
                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
