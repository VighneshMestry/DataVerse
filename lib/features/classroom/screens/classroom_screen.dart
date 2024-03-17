import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/check_permissions.dart';
import 'package:ml_project/common/subject_card.dart';
import 'package:ml_project/constants/constants.dart';
import 'package:ml_project/features/classroom/controller/classroom_controller.dart';
import 'package:ml_project/features/classroom/screens/create_new_subject_screen.dart';
import 'package:ml_project/features/classroom/screens/joining_classroom_screen.dart';
import 'package:ml_project/features/classroom/screens/subject_docs_display.dart';
import 'package:ml_project/features/home/drawers/profile_drawer.dart';
import 'package:ml_project/features/home/screens/search_sreen.dart';

class ClassroomScreen extends ConsumerStatefulWidget {
  const ClassroomScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ClassroomScreenState();
}

class _ClassroomScreenState extends ConsumerState<ClassroomScreen> {
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
          leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
          title: const Text("Classroom"),
          actions: [
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 14),
            child: IconButton(
                onPressed: () async {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchScreen()));
                },
                icon: const Icon(
                  Icons.search,
                  size: 28,
                )),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 12, top: 12, bottom: 12, right: 15),
              child: IconButton(
                  onPressed: () async {
                    // await LaunchApp.openApp(
                    //   androidPackageName: 'com. whatsapp',
                    //   // iosUrlScheme: 'pulsesecure://',
                    //   // appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
                    //   // openStore: false
                    // );
                    await DeviceApps.openApp('com.whatsapp');

                    // Enter the package name of the App you want to open and for iOS add the URLscheme to the Info.plist file.
                    // The `openStore` argument decides whether the app redirects to PlayStore or AppStore.
                    // For testing purpose you can enter com.instagram.android
                  },
                  icon: const Icon(Icons.published_with_changes_outlined,
                      size: 28)))
        ],
        ),
        drawer: const ProfileDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.grey),
                  height: 1,
                ),
                const SizedBox(height: 20),
                ref.watch(getJoinedClassroomProvider).when(
                      data: (data) {
                        return (data.isEmpty) ? const Center(child: Text("No Subjects found"),): ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SubjectDocsDisplyScreen(
                                      isPermission: isPermission,
                                      subject: data[index],
                                    ),
                                  ),
                                );
                              },
                              child: SubjectCard(
                                subject: data[index],
                                color: Constants.subjectColors[
                                    index % Constants.subjectColors.length],
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) => const Text("Error"),
                      loading: () => const CircularProgressIndicator(),
                    )

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
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
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
                            Container(height: 1, color: Colors.grey.shade300),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const JoiningClassroomScreen())),
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
                      ),
                    ),
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
