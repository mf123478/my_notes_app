
import 'package:my_notes_app/DB_Modal/db_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DBHelper {

  Database? _db;

  Future<Database?> get db async{
    if(_db != null){
      return _db;
    }

    _db = await initDataBase();

  }

  initDataBase()async{

    io.Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, 'notes1.db');

    var db = openDatabase(path,version: 1,onCreate: _onCreate);
     return db;
  }

  _onCreate(Database db, int version){

    return db.execute(
      "CREATE TABLE notes1 ( id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, age INTEGER, description TEXT NOT NULL, email TEXT NOT NULL)"
    );

  }

  Future<NotesModal> insert(NotesModal notesModal)async{
    var dbClient = await db;
    dbClient!.insert('notes1',
    notesModal.toMap()
    );
    return notesModal;
  }

  Future<List<NotesModal>> getNotesList()async{
    var dbClient = await db;

    List<Map<String, Object?>> getResult = await dbClient!.query('notes1');

    return getResult.map((e) => NotesModal.fromMap(e)).toList();
  }

  Future<int> delete(int id)async{
    var dbClient = await db;

    return dbClient!.delete('notes1',
      where: "id = ?",
      whereArgs:  [id],
    );
  }

  Future<int> update(NotesModal notesModal)async{
    var dbClient = await db;

    return dbClient!.update('notes1',
    notesModal.toMap(),
    where: "id = ?",
    whereArgs: [notesModal.id]
    );
  }



}