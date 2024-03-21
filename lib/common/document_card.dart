import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ml_project/constants/constants.dart';
import 'package:ml_project/directory_path.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/repository/services.dart';
import 'package:ml_project/features/my_classroom/repository/my_classroom_services.dart';
import 'package:ml_project/models/ai_document_model.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:pdf/widgets.dart' as pw;

class DocumentCard extends ConsumerStatefulWidget {
  final Doc document;
  const DocumentCard({
    super.key,
    required this.document,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DocumentCardState();
}

class _DocumentCardState extends ConsumerState<DocumentCard> {
  bool downloading = false;
  bool fileExists = false;
  bool aiFileExists = false;
  double progress = 0;
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();
  AIDoc aiDocument = AIDoc(
      fileName: "",
      aiDocId: "",
      mainDocId: "",
      userId: "",
      fileUrl: "",
      createdAt: "");

  startDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/${widget.document.fileName}';
    setState(() {
      downloading = true;
      progress = 0;
    });

    try {
      print("downloading>...........................");
      await Dio().download(widget.document.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        downloading = false;
        fileExists = true;
      });
      if (fileExists == true) {
        openfile();
      }
    } catch (e) {
      print(e);
      setState(() {
        downloading = false;
      });
    }
  }

  openfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  checkFileExist() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/${widget.document.fileName}';
    print("filePath-- $filePath");
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      fileExists = fileExistCheck;
      print(
          "last file check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! $fileExists");
    });
  }

  aiStartDownload() async {
    cancelToken = CancelToken();
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/AI ${widget.document.fileName}.pdf';
    setState(() {
      downloading = true;
      progress = 0;
    });

    try {
      print("downloading>...........................");
      await Dio().download(aiDocument.fileUrl, filePath,
          onReceiveProgress: (count, total) {
        setState(() {
          progress = (count / total);
        });
      }, cancelToken: cancelToken);
      setState(() {
        downloading = false;
        fileExists = true;
      });
      if (fileExists == true) {
        openfile();
      }
    } catch (e) {
      print(e);
      setState(() {
        downloading = false;
      });
    }
  }

  aiOpenfile() {
    OpenFile.open(filePath);
    print("fff $filePath");
  }

  aiCheckFileExist() async {
    var storePath = await getPathFile.getPath();
    filePath = '$storePath/AI ${widget.document.fileName}';
    print("filePath-- $filePath");
    bool fileExistCheck = await File(filePath).exists();
    setState(() {
      aiFileExists = fileExistCheck;
      print(
          "last file check!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! $aiFileExists");
    });
  }

  void share() async {
    var storePath = await getPathFile.getPath();
    final testFilePath = '$storePath/${widget.document.fileName}';
    await Share.shareFiles([testFilePath], text: "Sharing files");
  }

  void deleteDocument() async {
    try {
      // Get a reference to the document you want to delete
      DocumentReference documentReference =
          (widget.document.subjectJoiningCode.length == 0)
              ? FirebaseFirestore.instance
                  .collection('myDocuments')
                  .doc(widget.document.docId)
              : FirebaseFirestore.instance
                  .collection('documents')
                  .doc(widget.document.docId);
      await documentReference.delete();
    } catch (e) {
      rethrow;
    }
  }

  void updateNameDescriptionTags(WidgetRef ref, Doc doc) async {
    await ref.read(servicesProvider.notifier).updateNameDescriptionTags(doc);
  }

  void updateDocWithAiField(WidgetRef ref, Doc doc) async {
    await ref.read(servicesProvider.notifier).updateDocWithAiField(doc);
  }

  List<String> _splitStringIntoChunks(String largeString) {
    final int chunkLength = 700;
    final List<String> chunks = [];
    for (int i = 0; i < largeString.length; i += chunkLength) {
      int endIndex = i + chunkLength;
      if (endIndex > largeString.length) {
        endIndex = largeString.length;
      }
      chunks.add(largeString.substring(i, endIndex));
    }
    return chunks;
  }

  void askAI() async {
    await ref
        .read(servicesProvider.notifier)
        .contactServer(context, widget.document.fileUrl)
        .then((content) async {
      await ref
          .read(servicesProvider.notifier)
          .contactServerForAiDoc(context, content)
          .then((value) async {
        var storePath = await getPathFile.getPath();
        filePath = '$storePath/AI ${widget.document.fileName}';
        final pdf = pw.Document();

        // Split the large string into chunks/pages
        final List<String> chunks = _splitStringIntoChunks(value);
        // Loop through chunks and add them to PDF
        for (final chunk in chunks) {
          pdf.addPage(
            pw.Page(
              build: (pw.Context context) {
                return pw.Center(
                  child:
                      pw.Text(chunk, style: const pw.TextStyle(fontSize: 24)),
                );
              },
            ),
          );
        }
        File file = File(filePath);
        print(content + "|||||||||||||||||||||||||||||||||||||||||||");
        await file.writeAsBytes(await pdf.save());
        await ref
            .read(servicesProvider.notifier)
            .uploadPDF(context, file, "AI ${widget.document.fileName}");

        String aiFileUrl = await ref
            .read(servicesProvider.notifier)
            .getPdfDownloadUrl("AI ${widget.document.fileName}");

        final AiDocId = const Uuid().v1();
        aiDocument = AIDoc(
          fileName: "AI ${widget.document.fileName}",
          aiDocId: AiDocId,
          mainDocId: widget.document.docId,
          userId: widget.document.userId,
          fileUrl: aiFileUrl,
          createdAt:
              "${DateFormat("dd-MM-yyyy").format(DateTime.now())} ${TimeOfDay.now()}",
        );

        Doc document = widget.document.copyWith(aiFileExists: true);
        updateDocWithAiField(ref, document);
        await ref
            .read(servicesProvider.notifier)
            .uploadAIDocToFirebase(aiDocument);
        setState(() {
          aiFileExists = true;
        });
      });
    });
  }

  getAiDocument(String mainDocId) async {
    aiDocument =
        await ref.read(myClassroomServicesProvider).getAiDocument(mainDocId);
    setState(() {
      aiFileExists = true;
    });
  }

  int predictions = -1;
  void uploadToMySpace() async {
    String singleFilePath = await ref
        .read(servicesProvider.notifier)
        .getPdfDownloadUrl(widget.document.fileName);
    await ref
        .read(servicesProvider.notifier)
        .contactServer(context, singleFilePath)
        .then((content) async {
      predictions = predict(content);
      print(
          "$predictions PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
      final docId = const Uuid().v1();
      final document = Doc(
          fileName: widget.document.fileName,
          assignmentTitle: widget.document.assignmentTitle,
          assigmentDescription: widget.document.assigmentDescription,
          userId: ref.read(userProvider)!.uid,
          docId: docId,
          subjectJoiningCode: "",
          type: widget.document.type,
          fileUrl: singleFilePath,
          prediction: Constants.subjectTypes[predictions],
          aiFileExists: false,
          createdAt:
              "${DateFormat("dd-MM-yyyy").format(DateTime.now())} ${TimeOfDay.now()}",
          tags: widget.document.tags);
      await ref.read(servicesProvider.notifier).uploadToFirebase(document);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("File Uploaded to ${document.prediction}")));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
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
    if (widget.document.aiFileExists) {
      getAiDocument(widget.document.docId);
      aiFileExists = true;
    }
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
    TextEditingController assignmentTitle = TextEditingController();
    TextEditingController assignmentDescription = TextEditingController();
    TextEditingController tags = TextEditingController();
    return Container(
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade50,
            spreadRadius: 2,
            blurRadius: 3,
          ),
        ],
      ),
      // height: 150,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.assignment,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Enter Details'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: assignmentTitle,
                                        decoration: const InputDecoration(
                                            labelText: 'Assignment Name'),
                                      ),
                                      TextField(
                                        controller: assignmentDescription,
                                        decoration: const InputDecoration(
                                            labelText: 'Assignent Description'),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Perform submission actions here
                                        String assignmentTitleText =
                                            (assignmentTitle.text.length == 0)
                                                ? widget
                                                    .document.assignmentTitle
                                                : assignmentTitle.text.trim();
                                        String assignmentDescriptionText =
                                            (assignmentDescription
                                                        .text.length ==
                                                    0)
                                                ? widget.document
                                                    .assigmentDescription
                                                : assignmentDescription.text
                                                    .trim();
                                        Doc newDoc = widget.document.copyWith(
                                            assignmentTitle:
                                                assignmentTitleText,
                                            assigmentDescription:
                                                assignmentDescriptionText);
                                        updateNameDescriptionTags(ref, newDoc);

                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Submit'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            widget.document.assignmentTitle,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "Posted on ${widget.document.createdAt.substring(0, 10)} at ${widget.document.createdAt.substring(21, 26)}",
                          style: TextStyle(
                              fontSize: 14, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      Offset offset = details.globalPosition;
                      showMenu(
                          context: context,
                          color: Colors.white,
                          position: RelativeRect.fromLTRB(
                              offset.dx, offset.dy + 20, 10, 0),
                          items: [
                            PopupMenuItem(
                              onTap: () {
                                uploadToMySpace();
                              },
                              value: 1,
                              child: const Row(
                                children: [
                                  Icon(Icons.upload),
                                  SizedBox(width: 5),
                                  Text("Upload to My Space"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                share();
                              },
                              value: 2,
                              child: const Row(
                                children: [
                                  Icon(Icons.share),
                                  SizedBox(width: 5),
                                  Text("Share"),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: () {
                                (ref.read(userProvider)!.uid !=
                                        widget.document.userId)
                                    ? const SizedBox()
                                    : showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Delete Confirmation'),
                                            content: const Text(
                                                'Are you sure you want to delete this item?'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteDocument();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                              },
                              value: 3,
                              child: (ref.read(userProvider)!.uid !=
                                      widget.document.userId)
                                  ? const Row(
                                      children: [
                                        Icon(Icons.delete, color: Colors.grey),
                                        SizedBox(width: 5),
                                        Text("Delete",
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ],
                                    )
                                  : const Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 5),
                                        Text("Delete"),
                                      ],
                                    ),
                            ),
                            PopupMenuItem(
                              onTap: () {},
                              value: 4,
                              child: const Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 5),
                                  Text("Edit"),
                                ],
                              ),
                            ),
                          ]);
                    },
                    child: const Icon(Icons.more_vert_outlined),
                  ),
                ),
                // Text("Hello"),
              ],
            ),
            const SizedBox(height: 15),
            widget.document.assigmentDescription.isEmpty
                ? Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await checkFileExist();
                              fileExists ? openfile() : startDownload();
                              if (downloading) {
                                // ignore: use_build_context_synchronously
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      print(
                                          "Downloading dialog______________________________________________________");
                                      return AlertDialog(
                                        content: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              value: progress,
                                              strokeWidth: 3,
                                              backgroundColor: Colors.grey,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                            ),
                                            Text(
                                              (progress * 100)
                                                  .toStringAsFixed(2),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 8, top: 8, bottom: 8),
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  // (widget.document.type == "pdf")
                                  //     ? Icon(Icons.note,
                                  //         color: Colors.red.shade700)
                                  //     : ((widget.document.type == "docx")
                                  //         ? Icon(Icons.note,
                                  //             color: Colors.blue.shade700)
                                  //         : Icon(Icons.note,
                                  //             color: Colors.orange.shade700)),
                                  if (widget.document.type == "pdf?")
                                    Icon(Icons.note,
                                        color: Colors.red.shade700),
                                  if (widget.document.type == "docx")
                                    Icon(Icons.note,
                                        color: Colors.blue.shade700),
                                  if (widget.document.type == "xlsx")
                                    Icon(Icons.note,
                                        color: Colors.green.shade700),
                                  if (widget.document.type == "pptx")
                                    Icon(Icons.note,
                                        color: Colors.orange.shade700),
                                  if (widget.document.type == "img")
                                    Icon(Icons.image),
                                  const SizedBox(width: 10),
                                  Text((widget.document.fileName.length > 23)
                                      ? widget.document.fileName
                                          .substring(0, 23)
                                      : widget.document.fileName),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            height: 40,
                            width: 99,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                              onPressed: () {
                                askAI();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: const Text(
                                  "Ask AI",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      widget.document.aiFileExists
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await aiCheckFileExist();
                                    aiFileExists
                                        ? aiOpenfile()
                                        : aiStartDownload();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 8, bottom: 8),
                                    height: 40,
                                    width: 250,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.note,
                                            color: Colors.red.shade700),
                                        const SizedBox(width: 10),
                                        Text(
                                            (aiDocument.fileName.length == 0)
                                                ? ""
                                                : (aiDocument.fileName.length > 23) ? aiDocument.fileName.substring(0,23) : aiDocument.fileName,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  height: 40,
                                  width: 99,
                                  child: ElevatedButton(
                                    autofocus: true,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 3,
                                    ),
                                    onPressed: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Icon(Icons.mic_none_rounded),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(height: 40),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 45,
                        child: Text(
                          widget.document.assigmentDescription,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await checkFileExist();
                              fileExists ? openfile() : startDownload();
                              if (downloading) {
                                // ignore: use_build_context_synchronously
                                showDialog(
                                    barrierDismissible: true,
                                    context: context,
                                    builder: (context) {
                                      print(
                                          "Downloading dialog______________________________________________________");
                                      return AlertDialog(
                                        content: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircularProgressIndicator(
                                              value: progress,
                                              strokeWidth: 3,
                                              backgroundColor: Colors.grey,
                                              valueColor:
                                                  const AlwaysStoppedAnimation<
                                                      Color>(Colors.blue),
                                            ),
                                            Text(
                                              (progress * 100)
                                                  .toStringAsFixed(2),
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            )
                                          ],
                                        ),
                                      );
                                    });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 8, top: 8, bottom: 8),
                              height: 40,
                              width: 250,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  if (widget.document.type == "pdf?")
                                    Icon(Icons.note,
                                        color: Colors.red.shade700),
                                  if (widget.document.type == "docx")
                                    Icon(Icons.note,
                                        color: Colors.blue.shade700),
                                  if (widget.document.type == "xlsx")
                                    Icon(Icons.note,
                                        color: Colors.green.shade700),
                                  if (widget.document.type == "pptx")
                                    Icon(Icons.note,
                                        color: Colors.orange.shade700),
                                  if (widget.document.type == "img")
                                    const Icon(Icons.image),
                                  const SizedBox(width: 10),
                                  Text((widget.document.fileName.length > 23)
                                      ? widget.document.fileName
                                          .substring(0, 23)
                                      : widget.document.fileName),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.all(4.0),
                            height: 40,
                            width: 99,
                            child: ElevatedButton(
                              autofocus: true,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 3,
                              ),
                              onPressed: () {
                                askAI();
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: const Text(
                                  "Ask AI",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      widget.document.aiFileExists
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await aiCheckFileExist();
                                    aiFileExists
                                        ? aiOpenfile()
                                        : aiStartDownload();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 8, top: 8, bottom: 8),
                                    height: 40,
                                    width: 250,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey.shade400),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.note,
                                            color: Colors.red.shade700),
                                        const SizedBox(width: 10),
                                        Text(
                                            (aiDocument.fileName.length == 0)
                                                ? ""
                                                : (aiDocument.fileName.length > 23) ? aiDocument.fileName.substring(0,23) : aiDocument.fileName,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  height: 40,
                                  width: 99,
                                  child: ElevatedButton(
                                    autofocus: true,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      elevation: 3,
                                    ),
                                    onPressed: () {},
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(30),
                                      child: Icon(Icons.mic_none_rounded),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : const SizedBox(height: 40),
                    ],
                  ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Row(
                children: [
                  const Text("Tags: "),
                  ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.document.tags.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 10,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red),
                          child: Text(
                            widget.document.tags[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Enter Tags'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: tags,
                                  decoration: const InputDecoration(
                                      labelText: 'Enter new tag'),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  String tagsText = tags.text;
                                  widget.document.tags.add(tagsText);
                                  List<String> newDocTags =
                                      widget.document.tags;
                                  Doc newDoc = widget.document
                                      .copyWith(tags: newDocTags);
                                  updateNameDescriptionTags(ref, newDoc);

                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Submit'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: const Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
