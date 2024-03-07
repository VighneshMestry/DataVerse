// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ml_project/common/document_card.dart';
import 'package:ml_project/features/my_classroom/controller/my_classroom_controller.dart';
import 'package:ml_project/features/my_classroom/repository/my_classroom_services.dart';
import 'package:ml_project/models/subject_model.dart';

class MySubjectDocsDisplayScreen extends ConsumerStatefulWidget {
  final Subject subject;
  final bool isPermission;
  const MySubjectDocsDisplayScreen({
    super.key,
    required this.subject,
    required this.isPermission,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MySubjectDocsDisplayScreenState();
}

class _MySubjectDocsDisplayScreenState
    extends ConsumerState<MySubjectDocsDisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject.name),
      ),
      body: widget.isPermission ? ref
          .watch(getMySubjectDocumentsProvider(widget.subject.subjectType))
          .when(
            data: (data) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(color: Colors.grey),
                        height: 1,
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          print("From ui part ${data[index].fileName}");
                          // return ListTile(
                          //   title: Container(
                          //     height: 50,
                          //     padding: const EdgeInsets.all(10),
                          //     decoration: BoxDecoration(
                          //         border:
                          //             Border.all(color: Colors.black, width: 0.5),
                          //         borderRadius: BorderRadius.circular(10)),
                          //     child: Text(
                          //       data[index].fileName,
                          //     ),
                          //   ),
                          // );
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: DocumentCard(
                              document: data[index],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (error, stackTrace) => Text("Error ${error.toString()}"),
            loading: () => const Center(child: CircularProgressIndicator()),
          ) : const Text("Permission Denied"),
    );
  }
}
