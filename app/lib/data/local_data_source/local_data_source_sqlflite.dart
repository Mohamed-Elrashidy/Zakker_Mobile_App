import 'package:app/data/models/note_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../utils/app_constants.dart';

class LocalDataSource {
   Database? _db = null;
    int _version = 1;


  Future<void> initDb() async {
    print('/////////enter db');
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'Nottes.db';

        _db = await openDatabase(_path, version: _version,
            onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
            'CREATE TABLE ${AppConstants.notesList} (  title STRING, body STRING ,image STRING, category STRING,page String,source String, id Integer Primary Key AUTOINCREMENT, color String,date STRING) ',
          );
          await db.execute(
              'CREATE TABLE ${AppConstants.favoriteList} (  id Integer ,FOREIGN KEY (id) REFERENCES Persons(${AppConstants.notesList}) )');
          await db.execute(
              'CREATE TABLE ${AppConstants.todaysList} (  id Integer ,FOREIGN KEY (id) REFERENCES Persons(${AppConstants.notesList}) )');
          await db
              .execute('CREATE TABLE ${AppConstants.lastDayUpdated} (  id Integer Primary Key)');

          await db.execute(
            'CREATE TABLE ${AppConstants.categoryList} (  title STRING,  id Integer Primary Key AUTOINCREMENT, color String,numberOfNotes Integer) ',
          );
          await db.execute(
            'CREATE TABLE ${AppConstants.sourceList} (  title STRING,  id Integer Primary Key AUTOINCREMENT, color String, numberOfNotes Integer, categoryId Integer) ',
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

   Future<int?>insertData(String tableName, dynamic data) async {
    return await _db?.insert(tableName, data);
  }

  Future<List<Map<String, dynamic>>> getTable(String tableName) async {
    return await _db!.query(tableName);
  }

  void deleteData(String tableName, int id) async {
    await _db?.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

     queryData(String tableName, String key,var value) async {
    return await _db?.query(tableName, where: key, whereArgs: value);
  }
   updateData(String tableName,String parameters,var newValues,String key)async
  {
     await _db!.rawUpdate(
        'UPDATE $tableName $parameters  Where $key = ? ', newValues);
  }
   deleteTable(String tableName)
  {
    _db?.delete(tableName);
  }
}
