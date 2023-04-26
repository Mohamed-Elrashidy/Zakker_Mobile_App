import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db = null;
  static final int _version = 1;
  static final String _tableName = 'tasks';
  static Future<void> initDb() async {
    print('/////////enter db');
    if (_db != null) {
      debugPrint('not null db');
      return;
    } else {
      try {
        String _path = await getDatabasesPath() + 'task.p';

        _db = await openDatabase(_path, version: 1,
            onCreate: (Database db, int version) async {
              // When creating the db, create the table
              await db.execute(
                'CREATE TABLE tasks (  id INTEGER PRIMARY KEY AUTOINCREMENT, title STRING, note TEXT , isCompleted INTEGER, date STRING, startTime STRING, endTime STRING, color INTEGER,remind String , repeat STRING, day STRING, ka STRING) ',
              );
              print('Createdddddddddddddddddddddddddddddddd');
            });
      } catch (e) {
        print(e);
        print('Errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      }
      print('/////////////////////////////out dp');
    }
  }

  static Future<int> insert(Task? task) async {
    print(';insert');
    try {
      return _db!.insert('tasks', task!.toJson());
    } catch (e) {
      print(e);
      print('we are here');
      return 9000000;
    }
  }

  static Future<int> delete(Task? task) async {
    print(';delete');
    return await _db!.delete('tasks', where: 'id = ?', whereArgs: [task?.id]);
  }

  static Future<int> deleteAll() async {
    print(';delete');
    return await _db!.delete('tasks');
  }

  static Future<int> update(int id) async {
    print(';update');
    return await _db!
        .rawUpdate('UPDATE tasks SET isCompleted = ? Where id = ?', [1, id]);
  }

  static Future<dynamic> query() async {
    print('query');
    return await _db!.query(_tableName);
  }
}