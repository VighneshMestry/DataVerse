import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ml_project/features/auth/controller/auth_controller.dart';
import 'package:ml_project/features/auth/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ml_project/features/auth/screens/login_screen.dart';
import 'package:ml_project/features/home/screens/fetch_screen.dart';
import 'package:ml_project/models/user_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

// ignore: must_be_immutable
class MyApp extends ConsumerWidget {
  MyApp({super.key});

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) {
            if (data != null) {
              getData(ref, data);
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ML Application',
                home: FetchScreen());
            } else {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'ML Application',
                home: LoginScreen(),
              );
            }
          },
          error: (error, stackTrace) => const Text("Error"),
          loading: () => const CircularProgressIndicator(),
        );
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   // theme: ThemeData(
    //   //   // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //   //   // useMaterial3: true,
    //   // ),
    //   home: LoginScreen(),
    // );
  }
}
