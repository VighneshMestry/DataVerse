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
  int _currentpage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Documents"),
      ),
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          spreadRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(20)),
                child: TabBar(
                  // indicatorSize: 100,
                  labelColor: Colors.white,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(14, 61, 154, 1)),
                  tabs: const [
                    SizedBox(
                      width: 300,
                      child: Center(child: Text("File Search")),
                    ),
                    SizedBox(
                      width: 300,
                      child: Center(child: Text("Tags Search")),
                    ),
                  ],
                  onTap: (index) {
                    _currentpage = index;
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                  child: (_currentpage == 0)
                      ? const FileAndAssignmentNameSearch()
                      : const TagsSearch()),
            ],
          ),
        ),
      ),
    );
  }
}

class FileAndAssignmentNameSearch extends StatefulWidget {
  const FileAndAssignmentNameSearch({super.key});

  @override
  State<FileAndAssignmentNameSearch> createState() =>
      _FileAndAssignmentNameSearchState();
}

class _FileAndAssignmentNameSearchState
    extends State<FileAndAssignmentNameSearch> {
  String query = "";
  TextEditingController fileSearchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15, top: 10),
          child: Column(
            children: [
              Card(
                child: TextField(
                  controller: fileSearchController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              query = "";
                              fileSearchController.clear();
                            });
                          },
                          icon: const Icon(Icons.close)),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search...",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none)),
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
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
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
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: SizedBox(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
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
      ),
    );
  }
}

class TagsSearch extends StatefulWidget {
  const TagsSearch({super.key});

  @override
  State<TagsSearch> createState() => _TagsSearchState();
}

class _TagsSearchState extends State<TagsSearch> {
  String query = "";
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Card(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              query = "";
                              searchController.clear();
                            });
                          },
                          icon: const Icon(Icons.close)),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search...",
                      border: const OutlineInputBorder(
                          borderSide: BorderSide.none)),
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
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data();
                            Doc document = Doc.fromMap(data);

                            if (query.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: DocumentCard(document: document),
                              );
                            }
                            if (document.tags.contains(query.toLowerCase())) {
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
                  return (snapshots.connectionState == ConnectionState.waiting)
                      ? const Center(
                          child: SizedBox(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var data = snapshots.data!.docs[index].data();
                            Doc document = Doc.fromMap(data);

                            if (query.isEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: DocumentCard(document: document),
                              );
                            }
                            if (document.tags.contains(query.toLowerCase())) {
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
      ),
    );
  }
}
