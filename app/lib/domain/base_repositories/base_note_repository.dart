import 'package:app/domain/entities/note.dart';

import '../entities/category.dart';
import '../entities/source.dart';

abstract class BaseNoteRepository{
  Future<void> addNote(Note note);
  void editNote(Note note);
  void deleteNote(Note note);
  Future<List<Note>> getAllNotes();
  Future<List<Note>> showFavouriteNotes();
  Future<List<Note>> showTodaysNotes();
  void addToFavourites(int noteId);
  void deleteFromFavourites(int noteId);
  Future<List<Category>>showAllCategories();
  Future<List<Source>>showAllSources(int categoryId);




}