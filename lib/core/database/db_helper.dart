import 'package:balance/core/database/schem.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DbHelper {
  static final String _dbName = 'app.db';
  static final int _dbVersion = 1;

  static late Database _db;
  static Database get db => _db;

  static Future<void> initialize()async{
    var dbpath = await getDatabasesPath();
    var dbFullPath = join(dbpath, _dbName);
    var db = await openDatabase(dbFullPath, version: _dbVersion, onCreate: _onCreat);
    _db = db;
  }

}


Future<void> _onCreat(Database db, int version)async{
  var batch = db.batch();
  for (var schema in dbSchema) {
    batch.execute(schema);
  }
  await batch.commit();
  debugPrint("All tables are created!");
}