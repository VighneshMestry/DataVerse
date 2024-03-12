import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/common/custom_textfield.dart';
import 'package:ml_project/features/classroom/controller/classroom_controller.dart';
import 'package:ml_project/models/subject_model.dart';

class JoiningClassroomScreen extends ConsumerStatefulWidget {
  const JoiningClassroomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JoiningClassroomScreenState();
}

class _JoiningClassroomScreenState
    extends ConsumerState<JoiningClassroomScreen> {

  void joinClassroom (String subjectJoiningCode) {
    ref.read(classroomControllerProvider.notifier).joinSubject(subjectJoiningCode);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Joined the subject $subjectJoiningCode successfully")));
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _subjectJoiningCode = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Join subject",
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
                joinClassroom(_subjectJoiningCode.text.trim());
              },
              child: const Text(
                "Join",
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
                  controller: _subjectJoiningCode,
                  hintText: 'Joining code',
                ),
                const SizedBox(height: 10),
                const Text(
                    "* The joining code must be 8 alphanumeric characters *")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
