import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    var intitializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(intitializationSettings);
  }

  static Future showTodaysSessionNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifies =
        AndroidNotificationDetails(
            'your channel id',
                "your channel name",

            importance: Importance.max,
            priority: Priority.high);
    var notification = NotificationDetails(
      android: androidPlatformChannelSpecifies,
    );
    try{
      await fln.show(id, title, body, notification,payload:"this is the bodi");
      print("valid");

    }
catch(e) {
  print("reached");
}
  }
}
