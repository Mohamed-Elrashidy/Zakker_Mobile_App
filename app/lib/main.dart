import 'package:app/data/services/notification_services.dart';
import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/pages/bottom_nav_bar_page.dart';
import 'package:app/utils/app_routing.dart';
import 'package:app/utils/dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workmanager/workmanager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dependancy().initControllers();
  await Workmanager().initialize(
    NotificationServices.showNotesPeriodically,
    isInDebugMode: false
  );
  await Workmanager().registerPeriodicTask(
    "1",
    "fixed",
    frequency: Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
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
