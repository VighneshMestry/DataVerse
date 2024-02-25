import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  void requestNotificationPermission() async {
    NotificationSettings settings = await  messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      carPlay: true,
      criticalAlert: true,
    );

    if(settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("The user has given the permission0000000000000000000000000000000000000000000000000000");
    } else {
      print("The user has declined the permission00000000000000000000000000000000000000000000000000000000000");
    }
  }
}