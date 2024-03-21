import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/common/custom_textfield.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/classroom/controller/classroom_controller.dart';

class JoiningClassroomScreen extends ConsumerStatefulWidget {
  const JoiningClassroomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _JoiningClassroomScreenState();
}

class _JoiningClassroomScreenState
    extends ConsumerState<JoiningClassroomScreen> {
  void joinClassroom(String subjectJoiningCode) {
    ref
        .read(classroomControllerProvider.notifier)
        .joinSubject(subjectJoiningCode);
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Joined the subject $subjectJoiningCode successfully")));
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
                minimumSize: const Size(100, 30),
                maximumSize: const Size(100, 30),
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
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade400),
                  height: 1,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "You're currently signed in as",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.green.shade900,
                      child: const Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.read(userProvider)!.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        "mestryvighnesh27@gmail.com",
                        style: TextStyle(color: Colors.grey.shade600),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(color: Colors.grey.shade400),
                height: 1,
              ),
              const SizedBox(height: 20),
              const Text(
                "Ask your teacher for the joining code, then enter it here.",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: _subjectJoiningCode,
                hintText: 'Joining code',
              ),
              const SizedBox(height: 30),
              const Text(
                "To sign in with joining code",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 15),
              const Text("* Use an authorised account", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text("* The joining code must be more than 8 alphanumeric characters", style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text("If you are having trouble to joining the subject, Contact us", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
