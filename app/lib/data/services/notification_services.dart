import 'dart:math';

import 'package:app/data/repositories/note_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';

import '../../domain/entities/note.dart';

class NotificationServices {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');
    var intitializationSettings =
        InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(intitializationSettings);
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifies =
        AndroidNotificationDetails('your channel id', "your channel name",
            importance: Importance.max, priority: Priority.high);
    var notification = NotificationDetails(
      android: androidPlatformChannelSpecifies,
    );
    try {
      await fln.show(id, title, body, notification,
          payload: "this is the bodi");
      print("valid");
    } catch (e) {
      print("reached");
    }
  }

  static void showNotesPeriodically() {


    Workmanager().executeTask((taskName, inputData) {
      List<Note> notes = GetIt.instance.get<NoteRepository>().getAllNotes();
      if (notes.isNotEmpty) {
        Random random =  Random();
        int randomNumber = random.nextInt(notes.length);
        showNotification(
            title: notes[randomNumber].title,
            body: notes[randomNumber].body,
            fln: GetIt.instance.get<FlutterLocalNotificationsPlugin>());

      }
      return Future.value(true);

    });

  }
}
