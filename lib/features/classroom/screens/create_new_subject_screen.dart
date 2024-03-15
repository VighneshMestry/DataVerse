import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/common/custom_textfield.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/classroom/controller/classroom_controller.dart';
import 'package:ml_project/models/subject_model.dart';
import 'package:uuid/uuid.dart';

class CreateNewSubjectScreen extends ConsumerStatefulWidget {
  const CreateNewSubjectScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewSubjectScreenState();
}

class _CreateNewSubjectScreenState
    extends ConsumerState<CreateNewSubjectScreen> {
  final TextEditingController _className = TextEditingController();
  final TextEditingController _subjectType = TextEditingController();
  final TextEditingController _createdBy = TextEditingController();
  final TextEditingController _subjectJoiningCode = TextEditingController();

  void createNewSubject(Subject subject) {
    ref
        .read(classroomControllerProvider.notifier)
        .createNewSubject(subject, context);
  }

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
              onPressed: () {
                if (_className.text.isNotEmpty &&
                    _subjectType.text.isNotEmpty &&
                    _createdBy.text.isNotEmpty &&
                    _subjectJoiningCode.text.isNotEmpty) {
                  if (_subjectJoiningCode.text.trim().length < 8) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "The joining code must be 8 alphanumeric characters")));
                  } else {
                    String subjectId = const Uuid().v1();
                    String userId = ref.read(userProvider)!.uid;
                    String userName = ref.read(userProvider)!.name;
                    Subject subject = Subject(
                      name: _className.text.trim(),
                      subjectId: subjectId,
                      subjectType: _subjectType.text.trim(),
                      backGroundImageUrl: "",
                      createdBy: userName,
                      creatorId: userId,
                      subjectJoiningCode:
                          _subjectJoiningCode.text.trim().toUpperCase(),
                      members: [userId],
                    );
                    createNewSubject(subject);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill all fields")));
                }
              },
              child: const Text(
                "Create",
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
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
              const SizedBox(height: 20),
            Column(
              children: [
                CustomTextField(
                  controller: _className,
                  hintText: 'Subject Name',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _subjectType,
                  hintText: 'Subject Type',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _createdBy,
                  hintText: 'Created By',
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: _subjectJoiningCode,
                  hintText: 'Subject joining code',
                ),
                const SizedBox(height: 10),
                const Text(
                    "* The joining code must be 8 alphanumeric characters *")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
