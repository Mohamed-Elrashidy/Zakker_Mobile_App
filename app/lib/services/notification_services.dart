import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import '../data/models/note_model.dart';
import '../main.dart';
import '../utils/routes.dart';

class NotificationServices {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/ic_launcher');
    var intitializationSettings =
        InitializationSettings(android: androidInitialize);

    await flutterLocalNotificationsPlugin.initialize(intitializationSettings,
        onDidReceiveBackgroundNotificationResponse: notificationNavigation,
        onDidReceiveNotificationResponse: notificationNavigation);
  }

  static notificationNavigation(NotificationResponse notificationResponse) {
    print('we entered notification');
    print("this is the paylod =>"+notificationResponse.payload.toString());
  /*  Navigator.of(MyApp.navigatorKey.currentState!.context)
        .pushNamed(Routes.todaysNotesPage);*/
    try {
      print("reached");
      NoteModel note =
          NoteModel.fromJson(jsonDecode(notificationResponse.payload!));

      Navigator.of(MyApp.navigatorKey.currentState!.context)
          .pushNamed(Routes.notePage, arguments: note);
    } catch (e) {
      print(e);
    }
  }
  static Future<void> checkNotificationLaunch() async {
    final NotificationAppLaunchDetails? launchDetails =
    await GetIt.instance.get<FlutterLocalNotificationsPlugin>().getNotificationAppLaunchDetails();
    if (launchDetails != null && launchDetails.didNotificationLaunchApp) {
      // App was launched from a notification
      print('App launched from notification!');
      final NotificationResponse? notification = launchDetails.notificationResponse;
      if (notification != null) {
        // Do something with the notification

        NoteModel note =
        NoteModel.fromJson(jsonDecode(notification.payload!));

        Navigator.of(MyApp.navigatorKey.currentState!.context)
            .pushNamed(Routes.notePage, arguments: note);
        print('Notification payload: ${notification.payload}');
      }
    }
  }
  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifies =
        const AndroidNotificationDetails('your channel id', "your channel name",
            importance: Importance.max, priority: Priority.high);
    var notification = NotificationDetails(
      android: androidPlatformChannelSpecifies,
    );
    try {
      await fln.show(id, title, body, notification,
          payload:payload);
      print("valid");
    } catch (e) {
      print("reached");
    }
  }
}
