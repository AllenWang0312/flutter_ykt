import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import './ykt/splash_page.dart';
import 'package:provider/provider.dart';

bool PROXY = false;

void main() {
  runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LoginState())
      ],
      child: MyApp(),)
      );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    //   statusBarColor: Colors.transparent, //or set color with: Color(0xFF0000FF)
    // ));

    // JPush jpush = JPush();
    // jpush.getRegistrationID().then((map) => deviceId = map);
    //
    // jpush.addEventHandler(
    //   // 接收通知回调方法。
    //   onReceiveNotification: (Map<String, dynamic> message) async {
    //     print("flutter onReceiveNotification: $message");
    //   },
    //   // 点击通知回调方法。
    //   onOpenNotification: (Map<String, dynamic> message) async {
    //     print("flutter onOpenNotification: $message");
    //   },
    //   // 接收自定义消息回调方法。
    //   onReceiveMessage: (Map<String, dynamic> message) async {
    //     print("flutter onReceiveMessage: $message");
    //   },
    // );

    return
      // LoginStateWidget(
      // data: LoginState(),
       MaterialApp(
        theme: ThemeData(backgroundColor: Colors.black), home:
      SplashPage(),
        // IndexPage(class_id: 0,class_name: '',count: 0,),
        navigatorObservers: [MyNavObserver()],
    ) ;
  }
}

class MyNavObserver  extends NavigatorObserver{
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
  }
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace();
  }

  @override
  void didStartUserGesture(Route route, Route? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }
}
