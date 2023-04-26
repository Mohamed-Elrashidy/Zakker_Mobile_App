import 'package:app/presentation/controllers/categories_controller/category_cubit.dart';
import 'package:app/presentation/controllers/note_controller/note_cubit.dart';
import 'package:app/presentation/pages/bottom_nav_bar_page.dart';
import 'package:app/utils/app_routing.dart';
import 'package:app/utils/dependency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Dependancy().initControllers();
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
