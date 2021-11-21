
import 'dart:async';
import 'package:notebook/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const TABLE_NAME = 'Notes';
  static const COLUMN_ID = '_id';
  static const COLUMN_TITLE = 'title';
  static const COLUMN_CONTENT = 'Content';
  static const COLUMN_TIME = 'time';


  DatabaseHelper._init();
  static final DatabaseHelper instance = DatabaseHelper._init();
  Database? _database;
  get database async {
    if (_database != null) return _database;
    _database = await createDB();
    return _database;
  }

  Future<Database> createDB() async {
    String dbpath = await getDatabasesPath();
    return await openDatabase(
        join(dbpath, 'demo.db'),
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute('''
            CREATE TABLE $TABLE_NAME (
            $COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,
            $COLUMN_TITLE TEXT NOT NULL,
            $COLUMN_CONTENT TEXT NOT NULL,
            $COLUMN_TIME TEXT NOT NULL
            )
                ''');
        }
    );
  }


  createNote(Note note) async {
    Database db = await database;
    await db.insert(TABLE_NAME, note.toMap());
  }

  deleteNotes() async {
    Database db = await database;
    await db.delete(TABLE_NAME);
  }

  deleteNote(int noteId)async{
    final db = await database;
    await db.delete(
        TABLE_NAME,
        where: '_id = ?',
        whereArgs: [noteId],
    );
  }

  Future<int> updateNote(Note note) async {
    final db = await database;
    return db.update(
      TABLE_NAME,
      note.toMap(),
      where: '_id = ?',
      whereArgs: [note.noteId],
    );
  }

  Future<List<Note>?> getNotes() async {
    Database db = await database;
    List<Map<String, dynamic>> notes = await db.query( TABLE_NAME,
      orderBy: '$COLUMN_TIME ASC',);
    List<Note> noteList = [];
    notes.forEach((xNotes){
      Note note = Note.fromMap(xNotes);
      noteList.add(note);
    });
    print(noteList);
    return noteList;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}

