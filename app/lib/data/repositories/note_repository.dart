import 'package:app/data/local_data_source/local_data_source.dart';
import 'package:app/data/models/note_model.dart';
import 'package:app/domain/entities/category.dart';

import 'package:app/domain/entities/note.dart';

import '../../domain/base_repositories/base_note_repository.dart';

class NoteRepository extends BaseNoteRepository{
  final LocalDataSource localDataSource;
  NoteRepository({required this.localDataSource});
  @override
  void addNote(Note note) {

    localDataSource.addNote(_convertFromNoteToNoteModel(note));

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
  void deleteNote(int noteId) {

    localDataSource.deleteNote(noteId);
  }

  @override
  void editNote(Note note) {
    localDataSource.editNote(_convertFromNoteToNoteModel(note));


  }

  @override
  List<Note> getAllNotes() {
   List<Note> allNotes=[];
    localDataSource.getAllNotes().forEach((element) {
      allNotes.add(_convertFromNoteModelToNote(element));
    });
    return allNotes;

  }



  @override
  List<Category> showAllCategories() {
    // TODO: implement showAllCategories
    throw UnimplementedError();
  }

  @override
  List<Category> showAllSources() {
    // TODO: implement showAllSources
    throw UnimplementedError();
  }

  @override
  List<Note>showFavouriteNotes() {
    List<Note> favouriteNotes=[];
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

  NoteModel _convertFromNoteToNoteModel(Note note){
    NoteModel noteModel=NoteModel(title: note.title, body: note.body, image: note.image, category: note.category, page: note.page, source: note.source, id: note.id, color: note.color, date: note.date)
    return noteModel;
}

Note _convertFromNoteModelToNote(NoteModel noteModel){
    Note note=Note(title: noteModel.title, body: noteModel.body, image: noteModel.image, category: noteModel.category, page: noteModel.page, source: noteModel.source, id: noteModel.id, color: noteModel.color, date: noteModel.date)
    return note;
}
}