import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateNewSubjectScreen extends ConsumerStatefulWidget {
  const CreateNewSubjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewSubjectScreenState();
}

class _CreateNewSubjectScreenState
    extends ConsumerState<CreateNewSubjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create subject",
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
              onPressed: () {},
              child: const Text("Create", style: TextStyle(color: Colors.white),),
            ),
          ),
          const Icon(Icons.more_vert)
        ],
      ),
    );
  }
}
