import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:notebook/database/database.dart';
import 'package:notebook/model/note_model.dart';
import 'package:notebook/pages/Popup_theme_page.dart';
import 'package:notebook/Provider/theme.dart';
import 'package:provider/provider.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  late List<Note>? noteList;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  @override
  void dispose() {
    super.dispose();
    DatabaseHelper.instance.close();
  }


  Future loadNotes() async{
    final noteListt = await DatabaseHelper.instance.getNotes();
    noteList = noteListt ?? [];
  }
  int noteNo(){
    return noteList!.length;
  }

  void _deleteNote (int id) async{
    var result = await DatabaseHelper.instance.deleteNote(id);
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


  String formatDateTime(DateTime x)=> '${x.hour}:${x.minute}    ${x.day}-${x.month}-${x.year}';


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:loadNotes(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Scaffold(
              backgroundColor:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
            body:Center(
              child: CircularProgressIndicator()
            )
          );
        }else
          if(snapshot.error != null) {
            return Scaffold(
                backgroundColor:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
                body: Center(
                    child: Text('Your Notebook is not responding')
                )
            );
          }else
          if(snapshot.connectionState == ConnectionState.done){
            if (snapshot.hasError) {
              return Scaffold(
                body: Center(
                    child: Text('Your Notebook is not responding')
                ),
                floatingActionButton: FloatingActionButton(
                  heroTag: "btn2",
                  tooltip: 'Create Note',
                  backgroundColor: Colors.yellowAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/Notes', arguments: null);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey[850],
                  ),
                ),
              );
          } else
              return Scaffold(
                backgroundColor:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
                body: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 100.0, horizontal: 0.0),
                        child: Column(
                          children: [
                            Text(
                              'NoteBook',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 45.0,
                                color: Colors.yellowAccent,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 20.0,),
                            Text(
                              '${noteNo()} notes',
                              style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                              color:Provider.of<ToggleTheme>(context).isLightTheme? Colors.grey[850]: Colors.white,
                            ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Expanded(child: Container()),
                          SelectButton(),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: noteList!.length,
                            itemBuilder: (_, i) {
                              return Dismissible(
                                key: ValueKey(noteList![i].noteId),
                                direction: DismissDirection.startToEnd,
                                onDismissed:(DismissDirection direction){ setState((){noteList!.removeAt(i);});},
                                confirmDismiss: (direction) async {
                                  final result = await showDialog(
                                      context: context,
                                      builder: (_) =>
                                          deleteDialog(noteList![i].noteId!)
                                  );
                                  return result;
                                },
                                background: Container(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0),
                                    child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.delete,
                                            color: Colors.yellowAccent)),
                                  ),
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/Notes',
                                        arguments: this.noteList![i]);
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 90.0,
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color:Provider.of<ToggleTheme>(context).isLightTheme? Colors.grey[850]: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${noteList![i].title}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
                                                  fontSize: 19.0,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${noteList![i].content}',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(
                                                  color:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            formatDateTime(
                                                noteList![i].dateUpdated),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                            color:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
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
                floatingActionButton: FloatingActionButton(
                  heroTag: "btn2",
                  tooltip: 'Create Note',
                  backgroundColor: Colors.yellowAccent,
                  onPressed: () {
                    Navigator.pushNamed(context, '/Notes', arguments: null);
                  },
                  child: Icon(
                    Icons.edit,
                    color: Colors.grey[850],
                  ),
                ),
              );
        }else
          return Scaffold(
              backgroundColor:Provider.of<ToggleTheme>(context).isLightTheme? Colors.white: Colors.grey[850],
              body:Center(
                child: Text('An error occurred')
              )
          );
      }
    );
  }
}


