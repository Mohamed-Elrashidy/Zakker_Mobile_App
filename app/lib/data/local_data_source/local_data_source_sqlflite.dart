import 'package:app/data/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db = null;
  static const int _version = 1;
  static const String tableName = 'notes';
  static const String favouritesTableName = 'favourites';
  static const String todaysSessionNotesIds = "todays";
  static const String sesionDay = "day";
  static const String categoryTable = "category";
  static const String sourceTable = "source";

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
            'CREATE TABLE $tableName (  title STRING, body STRING ,image STRING, category STRING,page String,source String, id Integer Primary Key AUTOINCREMENT, color String,date STRING) ',
          );
          await db.execute(
              'CREATE TABLE $favouritesTableName (  id Integer ,FOREIGN KEY (id) REFERENCES Persons($tableName) )');
          await db.execute(
              'CREATE TABLE $todaysSessionNotesIds (  id Integer ,FOREIGN KEY (id) REFERENCES Persons($tableName) )');
          await db
              .execute('CREATE TABLE $sesionDay (  id Integer Primary Key)');

          await db.execute(
            'CREATE TABLE $categoryTable (  title STRING,  id Integer Primary Key AUTOINCREMENT, color String,numberOfNotes Integer) ',
          );
          await db.execute(
            'CREATE TABLE $sourceTable (  title STRING,  id Integer Primary Key AUTOINCREMENT, color String, numberOfNotes Integer, categoryId Integer) ',
          );
          print(_db.toString());

          print('Createdddddddddddddddddddddddddddddddd');
        });
      } catch (e) {
        print('Errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      }
      print('/////////////////////////////out dp');
    }
  }

  static insertData(String tableName, dynamic data) async {
    return await _db?.insert(tableName, data);
  }

  static getTable(String tableName) async {
    return await _db!.query(tableName);
  }

  static deleteData(String tableName, int id) async {
    await _db?.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  static queryData(String tableName, String key,var value) async {
    return await _db?.query(tableName, where: '$key = ?', whereArgs: [value]);
  }
  static updateData(String tableName,String parameters,var newValues,String key)async
  {
    return await _db!.rawUpdate(
        'UPDATE $tableName $parameters  Where $key = ? ', newValues);
  }
  static deleteTable(String tableName)
  {
    _db?.delete(tableName);
  }
}
