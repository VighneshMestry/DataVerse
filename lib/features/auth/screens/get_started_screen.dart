import 'package:flutter/material.dart';
import 'package:ml_project/features/auth/repository/services.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  String stringData = "";

  void contactServer() async {
    Services services = Services();
    print("function in build");
    stringData = await services.contactServer(context, "");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("Called from init");
    contactServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: const Text("Execute"),
              ),
              Text(stringData)
            ],
          ),
        ),
      ),
    );
  }
}
