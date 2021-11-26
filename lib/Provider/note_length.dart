import 'package:flutter/cupertino.dart';

class NotesAvailable extends ChangeNotifier{
  int _length=0;
  get length => _length;
  void resetNotebook (){
   _length= _length-1;
   notifyListeners();
  }
}