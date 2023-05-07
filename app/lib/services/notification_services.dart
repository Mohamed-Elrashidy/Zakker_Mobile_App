import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    print(notificationResponse.payload);
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
          payload: "this is the body");
      print("valid");
    } catch (e) {
      print("reached");
    }
  }
}
