import 'package:app/presentation/pages/add_note_page.dart';
import 'package:app/presentation/pages/edit_note_page.dart';
import 'package:app/utils/routes.dart';
import 'package:flutter/material.dart';

import '../domain/entities/note.dart';
import '../presentation/pages/bottom_nav_bar_page.dart';
import '../presentation/pages/note_page.dart';

class AppRouting {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.notePage:
        final note = settings.arguments as Note;

        return MaterialPageRoute(
            builder: (_) => NotePage(note: note,), settings: settings);
      case Routes.bottomNavBarPage:
        return MaterialPageRoute(builder: (_) => BottomNavBarPage());
      case Routes.editNotePage:
        final note = settings.arguments as Note;
        return MaterialPageRoute(builder: (_)=>EditNotePage(note: note),settings:settings)  ;
      case Routes.addNotePage:
        return MaterialPageRoute(builder:(_)=>AddNotePage());

      default:
        return MaterialPageRoute(
            builder: (_) => BottomNavBarPage(), settings: settings);
    }
  }
}