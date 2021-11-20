import 'package:flutter/material.dart';
import 'package:notebook/pages/Home_Page.dart';
import 'package:notebook/pages/Text_Page.dart';

import 'model/note_model.dart';

void main()=> runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: RouteGenerator.generateRoute,
));

class RouteGenerator{
  static Route<dynamic> generateRoute(RouteSettings x){
    final args = x.arguments;
    switch(x.name){
      case '/':
        return MaterialPageRoute(builder: (_) => Home());

      case '/Notes':
        if (args is Note){
          return MaterialPageRoute(builder: (_) => Notepad(note: args));
      }
        else
        return MaterialPageRoute(builder: (_) => Notepad(note: null));
      default:
        return MaterialPageRoute(builder: (_) => Notepad(note: null));
    }
  }
}