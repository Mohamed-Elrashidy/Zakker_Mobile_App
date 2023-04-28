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
        _convertFromNoteToNoteModel(note).toJson(flag: false)).then(
        (value){
          print("id is "+value.toString());
        }
    );
    int? categoryId = null;
    int? categoryNoOfNotes;
   List<Map<String,dynamic>> temp= await  DBHelper.queryData(DBHelper.categoryTable, 'title', note.category);

    if (temp.isEmpty) {
      categoryId = await addCategory(CategoryModel(
          title: note.category, color: note.color, numberOfNotes: 1, id:0));
    } else {
      categoryId=temp[0]['id'];
      DBHelper.updateData(DBHelper.categoryTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! + 1, temp[0]['id']], 'id');
    }

 temp=  await DBHelper.queryData(DBHelper.sourceTable, 'title', note.source);

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
    DBHelper.insertData(DBHelper.favouritesTableName, {'id':noteId});
  }

  @override
  void deleteFromFavourites(int noteId) {
    DBHelper.deleteData(DBHelper.favouritesTableName, noteId);
  }

  @override
  Future<void> deleteNote(Note note) async {

    List<Map<String,dynamic>>  temp=  await DBHelper.queryData(DBHelper.sourceTable, 'title', note.source);
    if(temp[0]['numberOfNotes']!>1)
      DBHelper.updateData(DBHelper.sourceTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']], 'id');
    else
    {
      DBHelper.deleteData(DBHelper.sourceTable, temp[0]['id']);
    }
    temp= await  DBHelper.queryData(DBHelper.categoryTable, 'title', note.category);
    if(temp[0]['numberOfNotes']!>1)
      DBHelper.updateData(DBHelper.categoryTable, "SET numberOfNotes =?",
          [temp[0]['numberOfNotes']! - 1, temp[0]['id']], 'id');
    else
    {
      DBHelper.deleteData(DBHelper.categoryTable, temp[0]['id']);
    }

    DBHelper.deleteData(DBHelper.favouritesTableName, note.id);
    DBHelper.deleteData(DBHelper.todaysSessionNotesIds, note.id);
    DBHelper.deleteData(DBHelper.tableName, note.id);
  }

  @override
  void editNote(Note note) {
    DBHelper.updateData(DBHelper.tableName, "SET title =? , body =?", [note.title,note.body,note.id], 'id');
  }

  @override
  Future<List<Note>> getAllNotes()  async {
    List<Note> allNotes = [];
    List<Map<String, dynamic>> temp=await DBHelper.getTable(DBHelper.tableName);
    allNotes.addAll(temp.map(( value) => NoteModel.fromJson(value)).toList());

    return allNotes;
  }

  @override
  Future<List<Category>> showAllCategories() async {
    List<Category> allCategories = [];
    List<Map<String, dynamic>> temp=await DBHelper.getTable(DBHelper.categoryTable)??[];
    allCategories.addAll(temp.map(( value) => CategoryModel.fromJson(value)).toList());


    return allCategories;
  }

  @override
  Future<List<Source>> showAllSources(int categoryId) async {
    List<Source> allSources = [];
    List<Map<String, dynamic>> temp=await DBHelper.queryData(DBHelper.sourceTable, "categoryId", categoryId)??[];
    allSources.addAll(temp.map(( value) => SourceModel.fromJson(value)).toList());
    return allSources;
  }

  @override
  Future<List<Note>> showFavouriteNotes() async {
    List<Note> favouriteNotes = [];
    List<Map<String , dynamic>> temp =await DBHelper.getTable(DBHelper.favouritesTableName);
for (int i=0;i<temp.length;i++)
  {
    int currentId=temp[i]['id'];
    List<Map<String,dynamic>> note=await DBHelper.queryData(DBHelper.tableName, 'id', currentId);
    favouriteNotes.addAll(note.map(( value) => NoteModel.fromJson(value)).toList());
  }

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
        id: categoryModel.id);
  }

  Source _convertFromSourceModelToSource(SourceModel sourceModel) {
    return Source(
        title: sourceModel.title,
        color: sourceModel.color,
        numberOfNotes: sourceModel.numberOfNotes,
        id: sourceModel.id,
        categoryId: sourceModel.categoryId);
  }
}
