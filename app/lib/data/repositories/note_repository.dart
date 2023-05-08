import 'dart:math';
import 'package:app/data/models/category_model.dart';
import 'package:app/data/models/note_model.dart';
import 'package:app/domain/entities/category.dart';
import 'package:app/domain/entities/note.dart';
import 'package:app/domain/entities/source.dart';
import '../../domain/base_repositories/base_note_repository.dart';
import '../local_data_source/local_data_source_sqlflite.dart';
import '../models/source_model.dart';

class NoteRepository extends BaseNoteRepository {
  @override
  Future<void> addNote(Note note, {bool flag = true}) async {
    await DBHelper.insertData(DBHelper.tableName,
            _convertFromNoteToNoteModel(note).toJson(flag: false))
        .then((value) {});
    int? categoryId;
    List<Map<String, dynamic>> temp = await DBHelper.queryData(
        DBHelper.categoryTable, 'title=?', [note.category]);

    if (temp.isEmpty) {
      categoryId = await addCategory(CategoryModel(
          title: note.category, color: note.color, numberOfNotes: 1, id: 0));
    } else {
      categoryId = temp[0]['id'];
      DBHelper.updateData(DBHelper.categoryTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! + 1, temp[0]['id']], 'id');
    }

    temp = await DBHelper.queryData(DBHelper.sourceTable,
        'title=? and categoryId = ?', [note.source, categoryId]);

    if (temp.isEmpty) {
      await addSource(SourceModel(
          title: note.source,
          color: note.color,
          numberOfNotes: 1,
          id: 0,
          categoryId: categoryId!));
    } else {
      DBHelper.updateData(DBHelper.sourceTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes'] + 1, temp[0]['id']], 'id');
    }
    getAllNotes();
  }

  Future<int> addCategory(CategoryModel category) async {
    return await DBHelper.insertData(
        DBHelper.categoryTable, category.toJson(flag: false));
  }

  Future<void> addSource(SourceModel sourceModel) async {
    await DBHelper.insertData(
        DBHelper.sourceTable, sourceModel.toJson(flag: false));
  }

  @override
  void addToFavourites(int noteId, {bool flag = true}) {
    DBHelper.insertData(DBHelper.favouritesTableName, {'id': noteId});
  }

  @override
  void deleteFromFavourites(int noteId) {
    DBHelper.deleteData(DBHelper.favouritesTableName, noteId);
  }

  Future<void> deleteSource(String noteSource) async {
    List<Map<String, dynamic>> temp =
        await DBHelper.queryData(DBHelper.sourceTable, 'title=?', [noteSource]);
    if (temp[0]['numberOfNotes']! > 1) {
      DBHelper.updateData(DBHelper.sourceTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']], 'id');
    } else {
      DBHelper.deleteData(DBHelper.sourceTable, temp[0]['id']);
    }
  }

  Future<void> deleteCategory(String noteCategory) async {
    List<Map<String, dynamic>> temp = await DBHelper.queryData(
        DBHelper.categoryTable, 'title=?', [noteCategory]);
    if (temp[0]['numberOfNotes']! > 1) {
      DBHelper.updateData(DBHelper.categoryTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']], 'id');
    } else {
      DBHelper.deleteData(DBHelper.categoryTable, temp[0]['id']);
    }
  }

  @override
  Future<void> deleteNote(Note note) async {
    deleteSource(note.source);
    deleteCategory(note.category);
    DBHelper.deleteData(DBHelper.favouritesTableName, note.id);
    DBHelper.deleteData(DBHelper.todaysSessionNotesIds, note.id);
    DBHelper.deleteData(DBHelper.tableName, note.id);
  }

  @override
  void editNote(Note note) {
    DBHelper.updateData(DBHelper.tableName, "SET title =? , body =? , date=?",
        [note.title, note.body,DateTime.now().toString(), note.id], 'id');
  }

  @override
  Future<List<Note>> getAllNotes() async {
    List<Note> allNotes = [];
    List<Map<String, dynamic>> temp =
        await DBHelper.getTable(DBHelper.tableName);
    allNotes.addAll(temp.map((value) => NoteModel.fromJson(value)).toList());

    return allNotes;
  }

  @override
  Future<List<Category>> showAllCategories() async {
    List<Category> allCategories = [];
    List<Map<String, dynamic>> temp =
        await DBHelper.getTable(DBHelper.categoryTable) ?? [];
    allCategories
        .addAll(temp.map((value) => CategoryModel.fromJson(value)).toList());

    return allCategories;
  }

  @override
  Future<List<Source>> showAllSources(int categoryId) async {
    List<Source> allSources = [];
    List<Map<String, dynamic>> temp = await DBHelper.queryData(
            DBHelper.sourceTable, "categoryId=?", [categoryId]) ??
        [];
    allSources
        .addAll(temp.map((value) => SourceModel.fromJson(value)).toList());
    return allSources;
  }

  @override
  Future<List<Note>> showFavouriteNotes() async {
    List<Note> favouriteNotes = [];
    List<Map<String, dynamic>> temp =
        await DBHelper.getTable(DBHelper.favouritesTableName);
    for (int i = 0; i < temp.length; i++) {
      int currentId = temp[i]['id'];
      List<Map<String, dynamic>> note =
          await DBHelper.queryData(DBHelper.tableName, 'id=?', [currentId]);
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
      await updateSession();
    }

    todaysNotes = await getSessionNotes();

    return todaysNotes;
  }

  updateSession() async {
    Set<int> notesIndex = {};
    Random random = Random();
    List<Note> notes = await getAllNotes();
    await DBHelper.deleteTable(DBHelper.todaysSessionNotesIds);
    while (notesIndex.length < 10 && notesIndex.length < notes.length) {
      notesIndex.add(random.nextInt(notes.length));
    }

    for (int x in notesIndex) {
      await DBHelper.insertData(
          DBHelper.todaysSessionNotesIds, {'id': notes[x].id});
    }
    await DBHelper.deleteTable(DBHelper.sesionDay);
    await DBHelper.insertData(
        DBHelper.sesionDay, {'id': int.parse(DateTime.now().day.toString())});
  }

  Future<bool> checkDay() async {
    var temp = await DBHelper.getTable(DBHelper.sesionDay);
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

  Future<List<Note>> getSessionNotes() async {
    List<Note> todaysNotes = [];
    var temp = await DBHelper.getTable(DBHelper.todaysSessionNotesIds);
    for (int i = 0; i < temp.length; i++) {
      List<Map<String, dynamic>> result =
          await DBHelper.queryData(DBHelper.tableName, 'id=?', [temp[i]['id']]);
      if (result.isNotEmpty) todaysNotes.add(NoteModel.fromJson(result[0]));
    }

    return todaysNotes;
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
