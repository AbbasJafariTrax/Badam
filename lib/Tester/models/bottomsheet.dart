import 'package:flutter/material.dart';

class MyBottomSheetModel extends ChangeNotifier{
  bool _visible = true;
  get visible => _visible;
  void changeState(){
    _visible = !_visible;
    print(_visible);
    notifyListeners();
  }
}