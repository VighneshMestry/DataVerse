import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/screens/login_screen.dart';
import 'package:ml_project/features/home/screens/fetch_screen.dart';
import 'package:ml_project/models/user_model.dart';

// ignore: must_be_immutable
class GetStartedScreen extends ConsumerWidget {
  GetStartedScreen({super.key});

  String stringData = "";

  // void contactServer() async {
  //   Services services = Services();
  //   print("function in build");
  //   stringData = await services.contactServer(context, "");
  // }

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              getData(ref, data);
              print(userModel);
              print(
                  "HELLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLOOOOOOOOOOO");
              if (userModel != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const FetchScreen()));
              }
            }
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()));
            return null;  
          },
          error: (error, stackTrace) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        ),
    );
  }
}
