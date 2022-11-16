import 'package:flutter/cupertino.dart';

class Menu {
  String name;
  bool more = false;

  String? icon;
  int? msgCount = 0;
  String? info= " ";
  Function? onTap;

  Menu(
      {required this.name,
        required this.more,

         this.icon,
         this.msgCount,
         this.info ,
         this.onTap});
}
