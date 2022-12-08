import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/cert_detial.dart';
import 'package:flutter_ykt/ykt/pages/fragment/home_frag.dart';
import 'package:flutter_ykt/ykt/pages/index_page.dart';
import 'package:flutter_ykt/ykt/pages/login_page.dart';
import 'package:flutter_ykt/ykt/pages/setting_page.dart';
import 'package:flutter_ykt/ykt/pages/user_info_page.dart';
import 'package:flutter_ykt/ykt/pages/webview_page.dart';
import 'package:flutter_ykt/ykt/splash_page.dart';
import 'package:flutter/cupertino.dart';

class Nav {
  static const String splash = "app://splash";

  static const String login = "app://login";
  static const String index = "app://index";

  static const String certDetail = "app://cert/detail";
  static const String setting = 'app://user/setting';
  static const String userinfo = 'app://user/info';

  // Widget _getPage(String url, dynamic params) {
  //   if (url.startsWith('https://') || url.startsWith('http://')) {
  //     return WebViewPage(url, params);
  //   } else {
  //     switch (url) {
  //       case splash:
  //         return SplashPage();
  //       case login:
  //         return LoginPage();
  //       case index:
  //         return IndexPage();
  //       case certDetail:
  //         return CertDetailPage(params["id"].toString());
  //       case setting:
  //         return SettingPage(params);
  //       case userinfo:
  //         return UserInfoPage();
  //     }
  //   }
  //   return null;
  // }
  //
  // Nav.push(BuildContext context, String url) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return _getPage(url, null);
  //   }));
  // }
  //
  // Nav.pushWithParams(BuildContext context, String url, dynamic params) {
  //   Navigator.push(context, MaterialPageRoute(builder: (context) {
  //     return _getPage(url, params);
  //   }));
  // }
}
