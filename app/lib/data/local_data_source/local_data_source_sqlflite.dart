import 'package:app/data/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db = null;
  static const int _version = 1;
  static const String _tableName = 'notes';
  static const String _favouritesTableName = 'favourites';
  static Future<void> initDb() async {
    print('/////////enter db');
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'Noes.db';

        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
            'CREATE TABLE $_tableName (  title STRING, body STRING ,image STRING, category STRING,page String,source String, id Integer Primary Key AUTOINCREMENT, color String,date STRING) ',
          );
          await db.execute(
              'CREATE TABLE $_favouritesTableName (  id Integer Primary Key)'
          );
          print(_db.toString());

          print('Createdddddddddddddddddddddddddddddddd');
        });
      } catch (e) {
        print("this is the errr " + e.toString());
        print('Errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      }
      print('/////////////////////////////out dp');
    }
  }

  static Future<int> insert(NoteModel? note) async {
    print(';insert');
    try {
      return await _db!.insert(_tableName, note!.toJson().remove('id'));
    } catch (e) {
      print(e);
      print('we are here');
      return 9000000;
    }
  }

  static Future<int> delete(NoteModel? note) async {
    print(';delete');
    return await _db!
        .delete(_tableName, where: 'id = ?', whereArgs: [note?.id]);
  }

  static Future<int> deleteAll() async {
    print(';delete');
    return await _db!.delete(_tableName);
  }

  static Future<int> update(NoteModel note) async {
    print(';update');
    return await _db!.rawUpdate(
        'UPDATE $_tableName SET title =?, body=?,date=?, Where id = ?',[note.title,note.body,DateTime.now(),note.id]);
  }

  static Future<dynamic> query() async {
    print(_db.toString());
    return await _db!.query(_tableName);
  }

  static insertToFavourites(int id)
  async {
    await _db?.insert(_favouritesTableName, {'id':id.toString()});
  }
  static deleteFromFavourites(int id)
  async {
    await _db?.delete(_favouritesTableName,where: 'id = ?', whereArgs: [id]);
  }
}
