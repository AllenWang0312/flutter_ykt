import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../common/util/platform_util.dart';
import '../pages/webview_page.dart';

class Menu {
  String name;
  bool more = false;
  String? h5Url = '';

  Function onTap = (context,Menu menu)=>{
   if(null!=menu.h5Url&&menu.h5Url!.isNotEmpty){
     PlatformUtil.loadUrl(context, menu.name, menu.h5Url!)
   }
  };

String? icon;
int? msgCount = 0;
String? info = " ";

Menu(this.name, this.more, {
  this.h5Url,
  this.icon,
  this.msgCount,
  this.info,
});}
