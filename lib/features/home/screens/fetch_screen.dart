import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/check_permissions.dart';
import 'package:ml_project/common/notifications.dart';
import 'package:ml_project/common/subject_card.dart';
import 'package:ml_project/constants/constants.dart';
import 'package:ml_project/features/home/screens/file_upload_screen.dart';
import 'package:ml_project/features/home/screens/my_subject_docs_display.dart';

class FetchScreen extends ConsumerStatefulWidget {
  const FetchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FetchScreenState();
}

class _FetchScreenState extends ConsumerState<FetchScreen> {
  bool isPermission = false;
  CheckPermission checkAllPermissions = CheckPermission();

  checkPermission() async {
    var permission = await checkAllPermissions.isStoragePermission();
    if (permission) {
      setState(() {
        isPermission = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        title: const Text("DataVerse"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
                onPressed: () async {
                  NotificationServices n = NotificationServices();
                  RemoteMessage message = RemoteMessage(
                      notification: RemoteNotification(
                          title: "Hello",
                          body: "This is notificaiton",
                          android: AndroidNotification(channelId: "0")));
                  await n.showNotification(message);
                },
                icon: const Icon(
                  Icons.search,
                  size: 28,
                )),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 15),
            child: Icon(Icons.published_with_changes_outlined, size: 28),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.grey),
                height: 1,
              ),
              SizedBox(height: 20),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: Constants.defaultSubjects.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySubjectDocsDisplayScreen(
                            isPermission: isPermission,
                            subject: Constants.defaultSubjects[index],
                          ),
                        ),
                      );
                    },
                    child: SubjectCard(
                      subject: Constants.defaultSubjects[index],
                      color: Constants.subjectColors[index],
                    ),
                  );
                },
              ),
              //   ref.watch(fetchDocsProvider).when(
              //       data: (data) {
              //         return ListView.builder(
              //           itemCount: data.length,
              //           itemBuilder: (context, index) {
              //             return Text(data[index].fileName);
              //           },
              //         );
              //       },
              //       error: (error, stackTrace) => Text(error.toString()),
              //       loading: () => const CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        padding: const EdgeInsets.all(5.0),
        height: 70,
        width: 70,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 30)),
                              child: const Text("Subject Upload",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const FileUploadScreen()));
                              },
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 30)),
                              child: const Text("Files Upload",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal)),
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 30)),
                              child: const Text(
                                "Scan",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal),
                              ),
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
      ),
    );
  }
}
