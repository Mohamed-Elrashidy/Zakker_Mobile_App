import 'dart:math';
import 'package:app/services/notification_services.dart';
import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/pages/bottom_nav_bar_page.dart';
import 'package:app/utils/app_routing.dart';
import 'package:app/utils/dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:workmanager/workmanager.dart';
import 'data/repositories/note_repository.dart';
import 'domain/entities/note.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    await Dependancy().initControllers();

    NotificationServices.showNotification(
        title: 'start', body: 'hi', fln: FlutterLocalNotificationsPlugin());
    print(' here at error');
    try {
      List<Note> notes =
          await GetIt.instance.get<NoteRepository>().getAllNotes();
      if (notes.isNotEmpty) {
        Random random = Random();
        int randomNumber = random.nextInt(notes.length);
        NotificationServices.showNotification(
            title: notes[randomNumber].title,
            body: notes[randomNumber].body,
            fln: GetIt.instance.get<FlutterLocalNotificationsPlugin>());
      } else {
        NotificationServices.showNotification(
            title: 'title',
            body: 'body',
            fln: GetIt.instance.get<FlutterLocalNotificationsPlugin>());
      }
      print('Valid');
    } catch (e) {
      NotificationServices.showNotification(
          title: 'error',
          body: e.toString(),
          fln: FlutterLocalNotificationsPlugin());
      print(' here at error');
    }

    return Future.value(true);
  });
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Dependancy().initControllers();

  await Workmanager().initialize(
    callbackDispatcher,
  );

  await Workmanager().registerPeriodicTask(
    "1",
    "fixed",
    frequency: Duration(minutes: 15),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoryCubit>(
      create: (context) => CategoryCubit(),
      child: BlocProvider<NoteCubit>(
        create: (BuildContext context) => NoteCubit(),
        child: MaterialApp(
            onGenerateRoute: AppRouting.generateRoutes,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: BottomNavBarPage()),
      ),
    );
  }
}
