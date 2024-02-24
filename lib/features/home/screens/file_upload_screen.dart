import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FileUploadScreen extends ConsumerStatefulWidget {
  const FileUploadScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FileUploadScreenState();
}

class _FileUploadScreenState extends ConsumerState<FileUploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Files"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {}, child: const Text("Upload files")))
        ],
      ),
    );
  }
}
