import 'dart:io';

import 'package:app/presentation/pages/add_note_page.dart';
import 'package:app/presentation/pages/category_sources_page.dart';
import 'package:app/presentation/pages/edit_note_page.dart';
import 'package:app/presentation/pages/pdf_reader_page.dart';
import 'package:app/presentation/pages/source_notes_page.dart';
import 'package:app/presentation/pages/todays_notes_page.dart';
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
            builder: (_) => NotePage(
                  note: note,
                ),
            settings: settings);
      case Routes.bottomNavBarPage:
        return MaterialPageRoute(builder: (_) => BottomNavBarPage());
      case Routes.editNotePage:
        final note = settings.arguments as Note;
        return MaterialPageRoute(
            builder: (_) => EditNotePage(note: note), settings: settings);
      case Routes.addNotePage:
        return MaterialPageRoute(builder: (_) => AddNotePage());
      case Routes.categorySourcesList:
        String category = settings.arguments as String  ;
        int categoryId=int.parse(category.split('|')[1]);
        category=category.split('|')[0];

        return MaterialPageRoute(
            builder: (_) => CategorySourcesPage(category: category,categoryId :categoryId),
            settings: settings);

      case Routes.todaysNotesPage:
        return MaterialPageRoute(builder: (_)=>TodaysNotesPage());

      case Routes.sourceNotesPage:
        String category = settings.arguments as String;
        String source = category.split(' ')[1];
        category = category.split(' ')[0];
        return MaterialPageRoute(
            builder: (_) => SourceNotesPage(category: category, source: source),
            settings: settings);
      case Routes.pdfReaderPage:
        File file =settings.arguments as File;
        return MaterialPageRoute(builder: (_)=>PdfReaderPage(file: file));
      default:
        return MaterialPageRoute(
            builder: (_) => BottomNavBarPage(), settings: settings);
    }
  }
}
