import 'package:app/domain/entities/note.dart';

import '../entities/category.dart';

abstract class BaseNoteRepository{
  void addNote(Note note);
  void editNote(Note note);
  void deleteNote(int noteId);
  List<Note> getAllNotes();
  List<Note> showFavouriteNotes();
  List<Note> showTodaysNotes();
  void addToFavourites(int noteId);
  void deleteFromFavourites(int noteId);
  List<Category>showAllCategories();
  List<Category>showAllSources();




}