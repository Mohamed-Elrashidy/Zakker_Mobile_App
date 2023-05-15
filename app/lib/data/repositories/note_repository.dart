import 'dart:math';
import 'package:app/data/models/category_model.dart';
import 'package:app/data/models/note_model.dart';
import 'package:app/domain/entities/category.dart';
import 'package:app/domain/entities/note.dart';
import 'package:app/domain/entities/source.dart';
import 'package:app/utils/app_constants.dart';
import '../../domain/base_repositories/base_note_repository.dart';
import '../data_source/local_data_source/local_data_source_sqlflite.dart';
import '../models/source_model.dart';

class NoteRepository extends BaseNoteRepository {
  LocalDataSource localDataSource;
  NoteRepository({required this.localDataSource});
  @override
  Future<void> addNote(Note note, {bool flag = true}) async {
  int? noteId=  await localDataSource
        .insertData(AppConstants.notesList,
            _convertFromNoteToNoteModel(note).toJson(flag: false))
        ;
    int? categoryId;
    List<Map<String, dynamic>> temp = await localDataSource
        .queryData(AppConstants.categoryList, 'title=?', [note.category]);

    if (temp.isEmpty) {
      categoryId = await addCategory(CategoryModel(
          title: note.category, color: note.color, numberOfNotes: 1, id: 0));
    } else {
      categoryId = temp[0]['id'];
      localDataSource.updateData(
          AppConstants.categoryList,
          "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! + 1, temp[0]['id']],
          'id');
    }

    temp = await localDataSource.queryData(AppConstants.sourceList,
        'title=? and categoryId = ?', [note.source, categoryId]);

    if (temp.isEmpty) {
      await addSource(SourceModel(
          title: note.source,
          color: note.color,
          numberOfNotes: 1,
          id: 0,
          categoryId: categoryId!));
    } else {
      localDataSource.updateData(
          AppConstants.sourceList,
          "SET numberOfNotes =?",
          [temp[0]['numberOfNotes'] + 1, temp[0]['id']],
          'id');
    }
    localDataSource.insertData(AppConstants.addedNotes, {'id':noteId});
    getAllNotes();
  }

  Future<int?> addCategory(CategoryModel category) async {
    return await localDataSource.insertData(
        AppConstants.categoryList, category.toJson(flag: false));
  }

  Future<void> addSource(SourceModel sourceModel) async {
    await localDataSource.insertData(
        AppConstants.sourceList, sourceModel.toJson(flag: false));
  }

  @override
  void addToFavourites(int noteId, {bool flag = true}) {
    localDataSource.insertData(AppConstants.favoriteList, {'id': noteId});
    localDataSource.insertData(AppConstants.addToFavourites, {'id': noteId});
    localDataSource.deleteData(AppConstants.deletedFromFavourites, noteId);
  }

  @override
  void deleteFromFavourites(int noteId) {
    localDataSource.deleteData(AppConstants.favoriteList, noteId);
    localDataSource.insertData(AppConstants.deletedFromFavourites, {'id':noteId});
    localDataSource.deleteData(AppConstants.addToFavourites, noteId);
  }

  Future<void> deleteSource(String noteSource) async {
    List<Map<String, dynamic>> temp =
    await localDataSource.queryData(AppConstants.sourceList, 'title=?', [noteSource]);
    if (temp[0]['numberOfNotes']! > 1) {
      localDataSource.updateData(AppConstants.sourceList, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']], 'id');
    } else {
      localDataSource.deleteData(AppConstants.sourceList, temp[0]['id']);
    }
  }


  Future<void> deleteCategory(String noteCategory) async {
    List<Map<String, dynamic>> temp = await localDataSource
        .queryData(AppConstants.categoryList, 'title=?', [noteCategory]);
    if (temp[0]['numberOfNotes']! > 1) {
      localDataSource.updateData(
          AppConstants.categoryList,
          "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']],
          'id');
    } else {
      localDataSource.deleteData(AppConstants.categoryList, temp[0]['id']);
    }
  }

  @override
  Future<void> deleteNote(Note note) async {
    deleteSource(note.source);
    deleteCategory(note.category);
    // for sync data
    localDataSource.deleteData(AppConstants.addedNotes,note.id);
    localDataSource.deleteData(AppConstants.addToFavourites,note.id);
    localDataSource.insertData(AppConstants.deletedFromFavourites,{'id':note.id});
    localDataSource.deleteData(AppConstants.editedList,note.id);
    // for local data
    localDataSource.deleteData(AppConstants.favoriteList, note.id);
    localDataSource.deleteData(AppConstants.todaysList, note.id);
    localDataSource.deleteData(AppConstants.notesList, note.id);
    localDataSource.insertData(AppConstants.deletedNotes, {'id':note.id});
  }

  @override
  void editNote(Note note) {
    localDataSource.updateData(
        AppConstants.notesList,
        "SET title =? , body =? , date=?",
        [note.title, note.body, DateTime.now().toString(), note.id],
        'id');
    localDataSource.insertData(AppConstants.editedList, {'id':note.id});
  }

  @override
  Future<List<Note>> getAllNotes() async {
    List<Note> allNotes = [];
    List<Map<String, dynamic>> temp =
        await localDataSource.getTable(AppConstants.notesList);
    allNotes.addAll(temp.map((value) => NoteModel.fromJson(value)).toList());

    return allNotes;
  }

  @override
  Future<List<Category>> showAllCategories() async {
    List<Category> allCategories = [];
    List<Map<String, dynamic>> temp =
        await localDataSource.getTable(AppConstants.categoryList) ?? [];
    allCategories
        .addAll(temp.map((value) => CategoryModel.fromJson(value)).toList());

    return allCategories;
  }

  @override
  Future<List<Source>> showAllSources(int categoryId) async {
    List<Source> allSources = [];
    List<Map<String, dynamic>> temp = await localDataSource
            .queryData(AppConstants.sourceList, "categoryId=?", [categoryId]) ??
        [];
    allSources
        .addAll(temp.map((value) => SourceModel.fromJson(value)).toList());
    return allSources;
  }

  @override
  Future<List<Note>> showFavouriteNotes() async {
    List<Note> favouriteNotes = [];
    List<Map<String, dynamic>> temp =
        await localDataSource.getTable(AppConstants.favoriteList);
    for (int i = 0; i < temp.length; i++) {
      int currentId = temp[i]['id'];
      List<Map<String, dynamic>> note = await localDataSource
          .queryData(AppConstants.notesList, 'id=?', [currentId]);
      favouriteNotes
          .addAll(note.map((value) => NoteModel.fromJson(value)).toList());
    }

    return favouriteNotes;
  }

  @override
  Future<List<Note>> showTodaysNotes() async {
    List<Note> todaysNotes = [];
    bool check = await checkDay();
    if (!check) {
      await _updateSession();
    }

    todaysNotes = await _getSessionNotes();

    return todaysNotes;
  }

  _updateSession() async {
    Set<int> notesIndex = {};
    Random random = Random();
    List<Note> notes = await getAllNotes();
    await localDataSource.deleteTable(AppConstants.todaysList);
    while (notesIndex.length < 10 && notesIndex.length < notes.length) {
      notesIndex.add(random.nextInt(notes.length));
    }

    for (int x in notesIndex) {
      await localDataSource
          .insertData(AppConstants.todaysList, {'id': notes[x].id});
    }
    await localDataSource.deleteTable(AppConstants.lastDayUpdated);
    await localDataSource.insertData(AppConstants.lastDayUpdated,
        {'id': int.parse(DateTime.now().day.toString())});
  }

  Future<bool> checkDay() async {
    var temp = await localDataSource.getTable(AppConstants.lastDayUpdated);
    try {
      print(int.parse(DateTime.now().day.toString()));
      print(temp[0]['id']);
      if (temp[0]['id'] == int.parse(DateTime.now().day.toString())) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<List<Note>> _getSessionNotes() async {
    List<Note> todaysNotes = [];
    var temp = await localDataSource.getTable(AppConstants.todaysList);
    for (int i = 0; i < temp.length; i++) {
      List<Map<String, dynamic>> result = await localDataSource
          .queryData(AppConstants.notesList, 'id=?', [temp[i]['id']]);
      if (result.isNotEmpty) todaysNotes.add(NoteModel.fromJson(result[0]));
    }

    return todaysNotes;
  }

  Future<Map<String, dynamic>> getNote(int noteId) async {
    List<Map<String, dynamic>> temp = [];
    temp =
        await localDataSource.queryData(AppConstants.notesList, 'id=?', [noteId])??{};
    Map<String,dynamic> note={};
    if(temp.isNotEmpty)
      {
        if(temp[0].isNotEmpty)
          note=temp[0];
      }

    return note;
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
}
