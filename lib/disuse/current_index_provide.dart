import 'package:flutter/material.dart';

//Button NavigationBar selected index Observable
class BNBIndexObservable with ChangeNotifier{
  int _index = 0;
  int get value => _index;
  BNBIndexObservable(this._index);

  changeIndex(int newIndex){
    _index=newIndex;
    notifyListeners();
  }
}