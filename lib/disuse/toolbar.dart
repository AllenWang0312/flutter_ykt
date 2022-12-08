// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Toolbar extends StatelessWidget {
//   String icon_left_res;
//   String title;
//   String icon_right_res;
//
//   Function leftClick;
//   Function rightClick;
//
//   Toolbar(
//       {Key? key, required this.title, this.icon_left_res, this.leftClick, this.icon_right_res, this.rightClick});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         InkWell(
//           child: Image.asset(icon_left_res),
//           onTap: leftClick,
//         ),
//         Expanded(
//           child: Text(title),
//         ),
//         InkWell(
//           child: Image.asset(icon_right_res),
//           onTap: rightClick,
//         ),
//       ],
//     );
//   }
// }
