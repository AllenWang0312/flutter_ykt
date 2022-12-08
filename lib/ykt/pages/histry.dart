
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HistryPage extends StatefulWidget {
  @override
  _HistryPageState createState()=> _HistryPageState();
}

class _HistryPageState extends State<HistryPage> {
  // var _footerKey = GlobalKey<RefreshFooterState>();
  
  @override
  Widget build(BuildContext context) {
    return   EasyRefresh(
      // footer: Footer(
      //   key: _footerKey,
      //   bgColor: Colors.white,
      //   textColor: KColor.refreshTextColor,
      //   moreInfoColor: KColor.refreshTextColor,
      //   showMore: true,
      //   noMoreText: "我是有底线的",
      //   moreInfo: KString.loading,
      //   loadReadyText: KString.loadReadyText,
      // ),
      child: Column(
        children: <Widget>[


        ],
      ),
      onLoad: () async {},
    );
  }
}