import 'dart:async';

import 'package:notebook/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class NotesProvider {
  static const TABLE_NAME = 'Notes';
  static const COLUMN_ID = '_id';
  static const COLUMN_TITLE = 'title';
  static const COLUMN_CONTENT = 'Content';
  static const COLUMN_TIME = 'time';

  NotesProvider._init();

  static NotesProvider db = NotesProvider._init();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return database;
    }
    _database = await createDB();
    return _database!;
  }

  Future<Database> createDB() async {
    String dbpath = await getDatabasesPath();
    return await openDatabase(
        join(dbpath, 'demo.db'),
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(
            'CREATE TABLE $TABLE_NAME ('
            '$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$COLUMN_TITLE TEXT,'
            '$COLUMN_CONTENT TEXT,'
            '$COLUMN_TIME TEXT,'
            ')'
          );
        }
    );
  }

  var result;
  Future<List<Note>> getNotes() async {
    final db = await database;
    var notes = await db.query(
      TABLE_NAME,
      orderBy: '$COLUMN_TIME ASC',
    );
    List<Note> noteList = [];
    notes.forEach((xNotes){
      Note note = Note.fromMap(xNotes);
    noteList.add(note);
    });
    return noteList;
  }

  Future <int> createNote (Note note)async{
    final db = await database;
    result = await db.insert(TABLE_NAME, note.toMap());
    return result;
  }


  Future <int> updateNote (Note note) async{
    final db = await database;
    result= await db.update(
      TABLE_NAME,
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.noteId]
    );
    return result;
  }

  Future <int> deleteNote (int noteId)async{
    final db = await database;
    result= await db.delete(
      TABLE_NAME,
      where: 'noteId = ?',
      whereArgs: [noteId]
    );
    return result;
  }

  Future close() async{
    final db = await database;
    db.close();
  }

}


