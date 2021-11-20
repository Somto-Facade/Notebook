


import 'package:notebook/Notes_db_provider.dart';

class Note{
  int? noteId;
  String title = '';
  String content = '';
  DateTime dateUpdated = DateTime.now();
  Note({
    this.noteId,
    required this.title,
    required this.content,
    required this.dateUpdated,
  });

  Map <String, dynamic> toMap () {
    var map = <String, dynamic>{
      NotesProvider.COLUMN_TITLE: title,
      NotesProvider.COLUMN_CONTENT: content,
      NotesProvider.COLUMN_TIME: dateUpdated.toIso8601String(),
    };

    if (noteId!= null){
      map[NotesProvider.COLUMN_ID]= noteId;
  }
    return map;
  }

  Note.fromMap (Map <String, dynamic> map) {
    noteId = map[NotesProvider.COLUMN_ID];
    title = map[NotesProvider.COLUMN_TITLE];
    content = map[NotesProvider.COLUMN_CONTENT];
    dateUpdated = DateTime.parse(map[NotesProvider.COLUMN_TIME] as String);
  }



}