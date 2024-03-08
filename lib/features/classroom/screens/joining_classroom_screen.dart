import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/common/custom_textfield.dart';

class JoiningClassroomScreen extends ConsumerWidget {
  const JoiningClassroomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                // if (_className.text.isNotEmpty &&
                //     _subjectType.text.isNotEmpty &&
                //     _createdBy.text.isNotEmpty &&
                //     _subjectJoiningCode.text.isNotEmpty) {
                //   if (_subjectJoiningCode.text.trim().length != 8) {
                //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //         content: Text(
                //             "The joining code must be 8 alphanumeric characters")));
                //   } else {
                //     String subjectId = const Uuid().v1();
                //     String userId = ref.read(userProvider)!.uid;
                //     String userName = ref.read(userProvider)!.name;
                //     Subject subject = Subject(
                //       name: _className.text.trim(),
                //       subjectId: subjectId,
                //       subjectType: _subjectType.text.trim(),
                //       backGroundImageUrl: "",
                //       createdBy: userName,
                //       subjectJoiningCode:
                //           _subjectJoiningCode.text.trim().toUpperCase(),
                //       members: [userId],
                //     );
                //     createNewSubject(subject);
                //   }
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //       const SnackBar(content: Text("Please fill all fields")));
                // }
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