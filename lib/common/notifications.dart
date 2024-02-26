import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ml_project/features/home/screens/file_upload_screen.dart';

  // void initState() {
  //   super.initState();
  //   loadModel();
  //   notificationServices.requestNotificationPermission();
  //   notificationServices.firebaseInit(context);
  //   notificationServices.setupInteractMessage(context);
  //   notificationServices.getDeviceToken().then((value) {
  //     print('device token');
  //     print(value);
  //   });
  // }

  // ElevatedButton(
  //               onPressed: () {
  //                 notificationServices.getDeviceToken().then((value) async {
  //                   var data = {
  //                     'to': value.toString(),
  //                     'priority': 'high',
  //                     'notification': {
  //                       'title': 'Vighnesh Mestry',
  //                       'body': 'how are you?'
  //                     },
  //                     'data': {'type': 'msg', 'id': '12345'}
  //                   };
  //                   await http
  //                       .post(Uri.parse("https://fcm.googleapis.com/fcm/send"), body: jsonEncode(data), headers: {
  //                     'Content-type': 'application/json; charset=UTF-8',
  //                     'Authorization':
  //                         'key=AAAA2r-5EpQ:APA91bEQzKZWjSa67I9OViUfkDS43vlfSDr1GN4zmQHknKyRWZzjfa72zFEMOnqFASeI-GMrEMjI7gGaQXoVK6BcLq3iq-zKptaIXL03SR-bWPd3JDK6jXZo-xAFopNYGBB43m-8ffjo'
  //                   });
  //                 });
  //               },
  //               child: const Text("Send Notification"),
  //             ),

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // void initLocalNotifications(
  //     BuildContext context, RemoteMessage message) async {}

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) async {
      if (Platform.isAndroid) {
        var androidInitializationSettings =
            const AndroidInitializationSettings('@mipmap/ic_launcher');
        var iosInitializationSettings = const DarwinInitializationSettings();

        var initializationSetting = InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

        await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
            onDidReceiveNotificationResponse: (payload) {
          // handle interaction when app is active for android // Payload is the additional data sent by the developer along with the notification
          handleMessage(context, message);
        });
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker',
            sound: channel.sound
            //     sound: RawResourceAndroidNotificationSound('jetsons_doorbell')
            //  icon: largeIconPath
            );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      // ignore: use_build_context_synchronously
      handleMessage(context, initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(context, message);
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      // ignore: use_build_context_synchronously
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const FileUploadScreen()));
    }
  }

  void requestNotificationPermission() async {
    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }
}
