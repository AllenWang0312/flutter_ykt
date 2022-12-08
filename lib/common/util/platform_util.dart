
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../ykt/pages/webview_page.dart';


class PlatformUtil{
   static void loadUrl(BuildContext context , String title,String url) async{
    if(Platform.isAndroid||Platform.isIOS){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return WebViewPage(title,url);
      }));
    }else{
      await launchUrl(Uri.parse(url));
    }
  }

}