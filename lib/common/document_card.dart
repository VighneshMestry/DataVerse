import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/constants/my_flutter_app_icons.dart';
import 'package:ml_project/features/auth/repository/services.dart';

import 'package:ml_project/models/document_model.dart';

class DocumentCard extends ConsumerWidget {
  final Doc document;
  const DocumentCard({
    super.key,
    required this.document,
  });

  void updateNameDescriptionTags(WidgetRef ref, Doc doc) async {
    await ref.read(servicesProvider.notifier).updateNameDescriptionTags(doc);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                                            ? document.assignmentTitle
                                            : assignmentTitle.text.trim();
                                    String assignmentDescriptionText =
                                        (assignmentDescription.text.length == 0)
                                            ? document.assigmentDescription
                                            : assignmentDescription.text.trim();
                                    Doc newDoc = document.copyWith(
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
                        "New Assignment: ${document.assignmentTitle}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Posted on ${document.createdAt}",
                      style:
                          TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            document.assigmentDescription.isEmpty
                ? Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                            left: 15, right: 8, top: 8, bottom: 8),
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            (document.type == "pdf")
                                ? Icon(CustomIcons.file_pdf,
                                    color: Colors.red.shade700)
                                : ((document.type == "docx")
                                    ? Icon(CustomIcons.doc_text,
                                        color: Colors.blue.shade700)
                                    : Icon(CustomIcons.table,
                                        color: Colors.green.shade700)),
                            const SizedBox(width: 10),
                            Text(document.fileName),
                          ],
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
                      document.assigmentDescription,
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
                    itemCount: document.tags.length,
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
                            document.tags[index],
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
                                  document.tags.add(tagsText);
                                  List<String> newDocTags = document.tags;
                                  Doc newDoc =
                                      document.copyWith(tags: newDocTags);
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

  void showDocumentEditingDialog(BuildContext context) {}
}
