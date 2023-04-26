import 'package:app/data/local_data_source/local_data_source.dart';
import 'package:app/data/models/category_model.dart';
import 'package:app/data/models/note_model.dart';
import 'package:app/domain/entities/category.dart';

import 'package:app/domain/entities/note.dart';

import '../../domain/base_repositories/base_note_repository.dart';

class NoteRepository extends BaseNoteRepository {
  final LocalDataSource localDataSource;
  NoteRepository({required this.localDataSource});
  @override
  void addNote(Note note) {
    note.id = localDataSource.generateId();
    print("note id is " + note.id.toString());
    localDataSource.addNote(_convertFromNoteToNoteModel(note));
    localDataSource.addToCategory(note.category, note.color);
    localDataSource.addSource(note.category, note.source, note.color);
  }

  @override
  void addToFavourites(int noteId) {
    localDataSource.addToFavourites(noteId);
  }

  @override
  void deleteFromFavourites(int noteId) {
    localDataSource.deleteFromFavourites(noteId);
  }

  @override
  void deleteNote(Note note) {
    localDataSource.deleteNote(_convertFromNoteToNoteModel(note));
  }

  @override
  void editNote(Note note) {
    localDataSource.editNote(_convertFromNoteToNoteModel(note));
  }

  @override
  List<Note> getAllNotes() {
    List<Note> allNotes = [];
    localDataSource.getAllNotes().forEach((element) {
      allNotes.add(_convertFromNoteModelToNote(element));
    });
    return allNotes;
  }

  @override
  List<Category> showAllCategories() {
    List<Category> allCategories = [];
    localDataSource.getAllCategories().forEach((element) {
      allCategories.add(_convertFromCategoryModelToCategory(element));
    });
    return allCategories;
  }

  @override
  List<Category> showAllSources(String category) {
    List<Category> allSources = [];
    localDataSource.getAllSources(category).forEach((element) {
      allSources.add(_convertFromCategoryModelToCategory(element));
    });
    return allSources;
  }

  @override
  List<Note> showFavouriteNotes() {
    List<Note> favouriteNotes = [];
    localDataSource.getFavouriteNotes().forEach((element) {
      favouriteNotes.add(_convertFromNoteModelToNote(element));
    });
    return favouriteNotes;
  }

  @override
  List<Note> showTodaysNotes() {
    // TODO: implement showTodaysNotes
    throw UnimplementedError();
  }

  NoteModel _convertFromNoteToNoteModel(Note note) {
    NoteModel noteModel = NoteModel(
        title: note.title,
        body: note.body,
        image: note.image,
        category: note.category,
        page: note.page,
        source: note.source,
        id: note.id,
        color: note.color,
        date: note.date);
    return noteModel;
  }

  Note _convertFromNoteModelToNote(NoteModel noteModel) {
    Note note = Note(
        title: noteModel.title,
        body: noteModel.body,
        image: noteModel.image,
        category: noteModel.category,
        page: noteModel.page,
        source: noteModel.source,
        id: noteModel.id,
        color: noteModel.color,
        date: noteModel.date);
    return note;
  }

  Category _convertFromCategoryModelToCategory(CategoryModel categoryModel) {
    return Category(
        title: categoryModel.title,
        color: categoryModel.color,
        numberOfNotes: categoryModel.numberOfNotes,
        isSource: categoryModel.isSource,
        isCategory: categoryModel.isCategory);
  }
}
