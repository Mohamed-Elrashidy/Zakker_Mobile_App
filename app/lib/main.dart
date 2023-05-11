import 'dart:convert';
import 'dart:math';
import 'package:app/data/models/note_model.dart';
import 'package:app/presentation/controllers/user_controller/user_cubit.dart';
import 'package:app/services/notification_services.dart';
import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/pages/bottom_nav_bar_page.dart';
import 'package:app/utils/app_routing.dart';
import 'package:app/utils/dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        title: 'start',
        body: 'hi',
        fln: GetIt.instance.get<FlutterLocalNotificationsPlugin>());
    print(' here at error');
    try {
      List<Note> notes =
      await GetIt.instance.get<NoteRepository>().getAllNotes();
      if (notes.isNotEmpty) {
        Random random = Random();
        int randomNumber = random.nextInt(notes.length);
        NoteModel noteModel = NoteModel(
            title: notes[randomNumber].title,
            body: notes[randomNumber].body,
            image: notes[randomNumber].image,
            category: notes[randomNumber].category,
            page: notes[randomNumber].page,
            source: notes[randomNumber].source,
            id: notes[randomNumber].id,
            color: notes[randomNumber].color,
            date: notes[randomNumber].date);
        NotificationServices.showNotification(
            title: notes[randomNumber].title,
            body: notes[randomNumber].body,
            fln: GetIt.instance.get<FlutterLocalNotificationsPlugin>(),
            payload: jsonEncode(noteModel.toJson())

        );
      }
      print('Valid');
    } catch (e) {
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
    frequency: const Duration(minutes: 30),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = new GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    NotificationServices.checkNotificationLaunch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(),
      child: BlocProvider<CategoryCubit>(
        create: (context) => CategoryCubit(),
        child: BlocProvider<NoteCubit>(
          create: (BuildContext context) => NoteCubit(),
          child: MaterialApp(
            //  theme: ThemeData.light(useMaterial3: true),

              navigatorKey: MyApp.navigatorKey,
              onGenerateRoute: AppRouting.generateRoutes,
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              home: BottomNavBarPage()),
        ),
      ),
    );
  }
}

