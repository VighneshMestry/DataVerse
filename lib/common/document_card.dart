// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ml_project/models/document_model.dart';

class DocumentCard extends ConsumerWidget {
  final Doc document;
  const DocumentCard({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey)
      ),
      height: 150,
      child: Column(
        children: [
          Text(document.assignmentTitle),
        ],
      ),
    );
  }
}
