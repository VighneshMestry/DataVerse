// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:ml_project/common/custom_textfield.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/repository/services.dart';
import 'package:ml_project/features/classroom/controller/classroom_controller.dart';
import 'package:ml_project/features/classroom/repository/classroom_repository.dart';
import 'package:ml_project/models/document_model.dart';
import 'package:ml_project/models/subject_model.dart';

class DetailedFileUploadScreen extends ConsumerStatefulWidget {
  final String subjectJoiningCode;
  const DetailedFileUploadScreen({
    super.key,
    required this.subjectJoiningCode,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailedFileUploadScreenState();
}

class _DetailedFileUploadScreenState
    extends ConsumerState<DetailedFileUploadScreen> {
  TextEditingController _assignmentTitle = TextEditingController();
  TextEditingController _assignmentDescription = TextEditingController();
  TextEditingController _tags = TextEditingController();
  TextEditingController _typeTitle = TextEditingController();

  void uploadCustomDocumentToFirebase() async {
    final result =
        await ref.read(classroomRepositoryProvider).pickSingleFile(context);
    File file = File(result!.files.single.path!);
    String fileName = result.files.single.name;
    // ignore: use_build_context_synchronously
    await ref
        .read(servicesProvider.notifier)
        .uploadPDF(context, file, fileName);
    String singleFilePath =
        await ref.read(servicesProvider.notifier).getPdfDownloadUrl(fileName);
    final docId = const Uuid().v1();
    ref.read(classroomControllerProvider.notifier).uploadCustomDocument(
          Doc(
            fileName: fileName,
            assignmentTitle: _assignmentTitle.text.trim(),
            assigmentDescription: _assignmentDescription.text.trim(),
            userId: ref.read(userProvider)!.uid,
            docId: docId,
            subjectJoiningCode: widget.subjectJoiningCode,
            type: "pdf",
            fileUrl: singleFilePath,
            prediction: "",
            createdAt:
                "${DateFormat("dd-MM-yyyy").format(DateTime.now())} ${TimeOfDay.now()}",
            tags: _tags.text.trim().split(' '),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Document",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: Size(100, 30),
                maximumSize: Size(100, 30),
              ),
              onPressed: () {
                if (_assignmentTitle.text.isNotEmpty &&
                    _assignmentDescription.text.isNotEmpty &&
                    _typeTitle.text.isNotEmpty &&
                    _tags.text.isNotEmpty) {
                  uploadCustomDocumentToFirebase();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")));
                }
              },
              child: const Text(
                "Upload",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CustomTextField(
                  controller: _assignmentTitle,
                  hintText: 'Assignment Title',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _assignmentDescription,
                  hintText: 'Assignment Description',
                  maxLines: 4,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _tags,
                  hintText: 'Add Tags',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _typeTitle,
                  hintText: 'Type format of the document',
                ),
                const SizedBox(height: 10),
                const Text("* All the fields are compulsory *")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
