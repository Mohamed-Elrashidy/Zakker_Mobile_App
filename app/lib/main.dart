import 'package:app/presentation/pages/add_note_page.dart';
import 'package:app/presentation/pages/bottom_nav_bar_page.dart';
import 'package:app/presentation/pages/category_page.dart';
import 'package:app/presentation/pages/edit_note_page.dart';
import 'package:app/presentation/pages/home_page.dart';
import 'package:app/presentation/pages/note_page.dart';
import 'package:app/presentation/pages/notes_page.dart';
import 'package:app/utils/app_routing.dart';
import 'package:app/utils/dimension_scale.dart';
import 'package:app/utils/dummy_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouting.generateRoutes,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:BottomNavBarPage());
  }
}
