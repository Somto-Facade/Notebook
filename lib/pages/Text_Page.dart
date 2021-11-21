import 'package:flutter/material.dart';
import 'package:notebook/database/database.dart';
//import 'package:notebook/Notes_db_provider.dart';
import 'package:notebook/model/note_model.dart';


class Notepad extends StatefulWidget {

  final Note? note;

  Notepad({this.note});

  @override
  _NotepadState createState() => _NotepadState(this.note);
}

class _NotepadState extends State<Notepad> {
  Note? note;
  //bool get isEditing=> widget.note!.noteId !=null;
  bool isLoading = false;
  String title ='';
  String content ='';
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  _NotepadState(this.note);


  void updateTitle(){
    setState(() {
      note?.title =_titleController.text;
      title = _titleController.text;
    });

  }
  void updateContent(){
    setState(() {
      note?.content =_contentController.text;
      content =_contentController.text;
    });
    //print(note?.content);
  }

  @override
  void initState() {
    _titleController.text = note?.title ?? title;
    _contentController.text = note?.content?? content;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void alertDialog(String message){
    AlertDialog _alertDialog= AlertDialog(
      elevation: 10.0,
      content: Text(message),
      actions: [
        TextButton(
            onPressed: (){Navigator.of(context).pop();}, child: Text('OK')),
      ],
    );
    showDialog(context: context, builder: (_)=> _alertDialog);
  }


  void saveNote()async{
    int  result;
    if (note == null){
      Note notee = Note(
        content: content,
        title: title,
        dateUpdated: DateTime.now(),
      );
      //print(notee);
       await DatabaseHelper.instance.createNote(notee);
    } else{
      await DatabaseHelper.instance.updateNote(note!);
      setState(() {
        isLoading = false;
      });
    }
    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {

    if (isLoading == true) {
      return Container(
        color: Colors.grey[850],
          child: Center(child: CircularProgressIndicator(),));
    }
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        title: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _titleController,
          onChanged: (value){updateTitle();},
          cursorHeight: 22.0,
          cursorColor: Colors.grey[800],
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Title',
              hintStyle: TextStyle(
                  color: Colors.grey[800]
              )
          ),
          style: TextStyle(
            fontSize: 21.0,
            color: Colors.white,
          ),
          autocorrect: true,
          textCapitalization: TextCapitalization.words,
        ),
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _contentController,
          onChanged: (value){updateContent();},
            cursorHeight: 22.0,
          decoration: InputDecoration(
              hintText: 'Type in Something...',
              hintStyle: TextStyle(
                  color: Colors.grey[500]
              ),
              border: InputBorder.none,
          ),
          style: TextStyle(
            fontSize: 19.0,
            color: Colors.white,
          ),
          autocorrect: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        onPressed: () {saveNote(); },
        child: Icon(Icons.save, color: Colors.grey[850],),
      ),
    );
  }
}
