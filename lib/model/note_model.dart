import 'package:notebook/database/database.dart';

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
      DatabaseHelper.COLUMN_TITLE: title,
      DatabaseHelper.COLUMN_CONTENT: content,
      DatabaseHelper.COLUMN_TIME: dateUpdated.toIso8601String(),
    };

    if (noteId!= null){
      map[DatabaseHelper.COLUMN_ID]= noteId;
  }
    return map;
  }

  Note.fromMap (Map <String, dynamic> map) {
    noteId = map[DatabaseHelper.COLUMN_ID];
    title = map[DatabaseHelper.COLUMN_TITLE];
    content = map[DatabaseHelper.COLUMN_CONTENT];
    dateUpdated = DateTime.parse(map[DatabaseHelper.COLUMN_TIME]);
  }



}