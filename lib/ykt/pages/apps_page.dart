// import 'dart:convert';
//
// import '../service/http_service.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class AppsPage extends StatefulWidget {
//   @override
//   _AppsPageState createState() {
//     return _AppsPageState();
//   }
// }
//
// class _AppsPageState extends State<AppsPage> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// //      appBar: Appbar(),
//       body: FutureBuilder(
//         future: post(context,'getClassList', formData: {"class_id": 1}),
//         // ignore: missing_return
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             var data = json.decode(snapshot.data.toString());
//             print(data);
//             List<Map> list = (data['data'] as List).cast();
//             return ListView.builder(
//               itemCount: list.length,
//               itemBuilder: (context, index) {
//                 return inflateItem(list[index]);
//               },);
//           } else {
//           return Container(
//           child: Text('加载中...'),
//           );
//           }
//         },
//       ),
//     );
//   }
//
//   inflateItem(Map<String, dynamic> item) {
//     return Column(
//       children: <Widget>[
//         Text(item['']),
//       ],
//     );
//   }
// }
