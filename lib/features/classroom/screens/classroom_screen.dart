import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/classroom/screens/create_new_subject_screen.dart';

class ClassroomScreen extends ConsumerStatefulWidget {
  const ClassroomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClassroomScreenState();
}

class _ClassroomScreenState extends ConsumerState<ClassroomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Container(
      padding: const EdgeInsets.all(5.0),
      height: 70,
      width: 70,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.white,
        onPressed: () {
          showDialog(
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    height: 200,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateNewSubjectScreen())),
                            style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 30)),
                            child: const Text("Create New subject",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 30)),
                            child: const Text("Join Subject",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal)),
                          ),
                        ],
                      ),
                    )),
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    ));
  }
}
