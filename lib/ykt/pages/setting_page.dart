import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ykt/custom/widgets/custom_appbar.dart';

class SettingPage extends StatefulWidget {
  dynamic userinfo;

  SettingPage(this.userinfo);

  @override
  State<StatefulWidget> createState() {
    return _SettingPageState();
  }
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: InkWell(
          child: Icon(Icons.arrow_back),
          onTap: (){Navigator.pop(context);}
        ),
        title: "设置",
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 48,
            child: Row(),
          )
        ],
      ),
    );
  }
}
