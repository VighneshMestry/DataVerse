import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ml_project/common/document_card.dart';
import 'package:ml_project/models/document_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Search Documents"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Card(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          setState(() {
                            query = "";
                            searchController.clear();
                          });
                        }, icon: const Icon(Icons.close)),
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Search...",
                        border:
                            const OutlineInputBorder(borderSide: BorderSide.none)),
                    onChanged: (val) {
                      setState(() {
                        query = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("myDocuments")
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data();
                              Doc document = Doc.fromMap(data);

                              if (query.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: DocumentCard(document: document),
                                );
                              }
                              if (document.fileName
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DocumentCard(document: document),
                                );
                              }
                              if (document.assignmentTitle
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DocumentCard(document: document),
                                );
                              }
                              return Container();
                            },
                            itemCount: snapshots.data!.docs.length,
                          );
                  },
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("documents")
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              var data = snapshots.data!.docs[index].data();
                              Doc document = Doc.fromMap(data);

                              if (query.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 15),
                                  child: DocumentCard(document: document),
                                );
                              }
                              if (document.fileName
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DocumentCard(document: document),
                                );
                              }
                              if (document.assignmentTitle
                                  .toString()
                                  .toLowerCase()
                                  .contains(query.toLowerCase())) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: DocumentCard(document: document),
                                );
                              }
                              return Container();
                            },
                            itemCount: snapshots.data!.docs.length,
                          );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
