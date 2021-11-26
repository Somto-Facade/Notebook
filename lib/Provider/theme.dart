import 'package:flutter/cupertino.dart';

class ToggleTheme extends ChangeNotifier{
  bool _isLightTheme= true;
  get isLightTheme=> _isLightTheme;

  void toggleTheme(){
    _isLightTheme =!_isLightTheme;
    notifyListeners();
  }
}