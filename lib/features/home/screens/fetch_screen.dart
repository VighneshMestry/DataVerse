import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/common/subject_card.dart';
import 'package:ml_project/constants/constants.dart';
import 'package:ml_project/features/home/services/fetch_services.dart';

class FetchScreen extends ConsumerWidget {
  const FetchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          leading: const Icon(Icons.menu),
          title: const Text("DataVerse"),
          actions: const [
            Padding(
              padding: EdgeInsets.all(12.0),
              child: Icon(
                Icons.search,
                size: 28,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 12, top: 12, bottom: 12, right: 15),
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
                    return SubjectCard(subject: Constants.defaultSubjects[index], color: Constants.subjectColors[index],);
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
        ));
  }
}
