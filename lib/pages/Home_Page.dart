import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notebook/model/note_model.dart';
import '../Notes_db_provider.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isLoading = true;
  late List<Note> noteList=[];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    super.dispose();
    NotesProvider.db.close();
  }


  void loadNotes() async{
    setState(() {isLoading = true;});
    this.noteList = await NotesProvider.db.getNotes();
    setState(() {isLoading = false;});
  }

  void _deleteNote (int id) async{
    var result = await NotesProvider.db.deleteNote(id);
    if (result != 0){
      alertDialog('Note Deleted Successfully');
    }else {
      alertDialog('Note Could Not Be Deleted');
    }
    loadNotes();
  }

  void alertDialog( String message){
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

  Widget deleteDialog(int x){
    return AlertDialog(
      elevation: 10.0,
      actions: [
        TextButton(
            onPressed: (){Navigator.of(context).pop(true);
            _deleteNote(x);
            }, child: Text('Delete')),
        TextButton(
            onPressed: (){Navigator.of(context).pop(false);}, child: Text('Undo')),
      ],
    );
  }


  String formatDateTime(DateTime x)=> '${x.hour}:${x.minute}  ${x.toString()} ${x.day}-${x.month}-${x.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[700],
      body: isLoading? Center(child: CircularProgressIndicator() ,) : Container(
        color: Colors.grey[850],
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 0.0),
              child: Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45.0,
                  color: Colors.yellowAccent,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(child: Container()),
                FloatingActionButton(
                  backgroundColor: Colors.grey[850],
                  onPressed: (){
                    Navigator.pushNamed(context, '/Setting');
                  },
                  child: Icon(
                    Icons.settings,
                    color: Colors.yellowAccent,
                  ),
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: noteList.length,
                  itemBuilder: (_, i){
                    return Dismissible(
                      key: ValueKey(noteList[i].noteId),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async{
                        final result = await showDialog(
                            context: context,
                            builder: (_)=>deleteDialog(noteList[i].noteId!)
                        );
                        return result;
                      },
                      background: Container(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(alignment: Alignment.centerLeft,
                              child: Icon(Icons.delete, color: Colors.yellowAccent)),
                        ),
                      ),
                      child: GestureDetector(
                        onTap: (){Navigator.pushNamed(context, '/Notes', arguments: this.noteList[i]);},
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${noteList[i].title}',
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${noteList[i].content}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  formatDateTime(noteList[i].dateUpdated),
                                  style: TextStyle(
                                    color: Colors.grey[850],
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
              ),
            )
          ],
        ),
      ),
      floatingActionButton:
      FloatingActionButton(
        tooltip: 'Create Note',
        backgroundColor: Colors.yellowAccent,
        onPressed: (){
          Navigator.pushNamed(context, '/Notes', arguments: Note(noteId: null, title: '', content: '', dateUpdated: DateTime.now()));
        },
        child: Icon(
          Icons.edit,
          color: Colors.grey[850],
        ),
      ),
    );
  }
}


