//
//
// import 'package:flutter/cupertino.dart';
//
// class LoginStateWidget extends InheritedWidget {
//   final LoginState data;
//
//   LoginStateWidget({required this.data, Key? key, required Widget child})
//       : super(key: key, child: child);
//
//   static LoginState of(BuildContext context) {
//     return context
//         .dependOnInheritedWidgetOfExactType<LoginStateWidget>()!
//         .data;
//   }
//
//   @override
//   bool updateShouldNotify(covariant LoginStateWidget oldWidget) {
//     return oldWidget.data.isLoged != data.isLoged||oldWidget.data.token!=data.token;
//     //||oldWidget.data.name != data.name||
//     // oldWidget.data.isPlaying != data.isPlaying
//   }
// }
//
// class LoginState {
//   bool isLoged = false;
//   String token = '';
//   String device = '';
//
// }