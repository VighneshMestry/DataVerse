// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ml_project/constants/my_flutter_app_icons.dart';
import 'package:ml_project/directory_path.dart';
import 'package:ml_project/features/auth/repository/services.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:open_file/open_file.dart';

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
  double progress = 0;
  late String filePath;
  late CancelToken cancelToken;
  var getPathFile = DirectoryPath();

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

  cancelDownload() {
    cancelToken.cancel();
    setState(() {
      downloading = false;
    });
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

  void updateNameDescriptionTags(WidgetRef ref, Doc doc) async {
    await ref.read(servicesProvider.notifier).updateNameDescriptionTags(doc);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController assignmentTitle = TextEditingController();
    TextEditingController assignmentDescription = TextEditingController();
    TextEditingController tags = TextEditingController();
    return Container(
      height: 240,
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
                                            ? widget.document.assignmentTitle
                                            : assignmentTitle.text.trim();
                                    String assignmentDescriptionText =
                                        (assignmentDescription.text.length == 0)
                                            ? widget
                                                .document.assigmentDescription
                                            : assignmentDescription.text.trim();
                                    Doc newDoc = widget.document.copyWith(
                                        assignmentTitle: assignmentTitleText,
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
                        "New Assignment: ${widget.document.assignmentTitle}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Posted on ${widget.document.createdAt.substring(0, 10)} at ${widget.document.createdAt.substring(21, 26)}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            widget.document.assigmentDescription.isEmpty
                ? Column(
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
                                  print("Downloading dialog______________________________________________________");
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
                                          (progress * 100).toStringAsFixed(2),
                                          style: const TextStyle(fontSize: 12),
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
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(
                            children: [
                              (widget.document.type == "pdf")
                                  ? Icon(CustomIcons.file_pdf,
                                      color: Colors.red.shade700)
                                  : ((widget.document.type == "docx")
                                      ? Icon(CustomIcons.doc_text,
                                          color: Colors.blue.shade700)
                                      : Icon(CustomIcons.table,
                                          color: Colors.green.shade700)),
                              const SizedBox(width: 10),
                              Text(widget.document.fileName),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  )
                : SizedBox(
                    height: 90,
                    child: Text(
                      widget.document.assigmentDescription,
                      style: const TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
            const SizedBox(height: 10),
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
            )
          ],
        ),
      ),
    );
  }
}
