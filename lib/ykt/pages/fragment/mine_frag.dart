import 'dart:convert';

import 'package:flutter_ykt/common/widgets/custom_appbar.dart';
import 'package:flutter_ykt/ykt/pages/setting_page.dart';
import 'package:flutter_ykt/ykt/util/ui_util.dart';
import 'package:provider/provider.dart';
import '../../service/http_service.dart';

import '../../model/menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../state/login_state_provider.dart';


class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() {
    return _MinePageState();
  }
}

class _MinePageState extends State<MinePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  var menus = [
    Menu(name: "我的证书", msgCount: 1, info: "4", more: true),
    Menu(name: "历史学习", more: true),
    Menu(name: "积分商城", more: true),
    Menu(name: "我的订单", more: true),
    Menu(name: "推荐给好友", more: true),
    Menu(name: "意见反馈", more: true),
    Menu(name: "帮助中心", more: true),
  ];
  String? _token;

  String? get token{
    _token ??= context.watch<LoginState>().token;
    return _token;
  }
  @override
  void initState() {
    super.initState();
  }

  dynamic info;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: const Icon(Icons.message),
        trailingWidget: InkWell(
          child: const Icon(Icons.settings),
          onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SettingPage(info);
              }));
          },
        ),
      ),
      body: createBody()
    );
//      EasyRefresh()
  }

  Widget nullableText(String? data) {
    if (null != data && data.isNotEmpty) {
      return Text(
        data,
        textAlign: TextAlign.right,
      );
    } else {
      return Stack();
    }
  }

  Widget infoCard() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: <Widget>[Image.asset('images/ic_right_arrow_gary.png')],
      ),
    );
  }

  Widget inflateMenu() {
    return ListView.builder(
      itemCount: menus.length,
      shrinkWrap: true, //height
      physics: const NeverScrollableScrollPhysics(), //禁止滑动
      itemBuilder: (context, index) {
        return Container(
          height: 56,
          padding: const EdgeInsets.only(left: 12, right: 6),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
//                        Container(
//                          width: 32,
//                          height: 32,
//                        child: Image.asset(menus[index].icon),
//                        ),
                    Text(menus[index].name,style: const TextStyle(fontSize: 16),),
                    Container(
                      width: 4,
                    ),
                    Visibility(
                      visible: null != menus[index].msgCount &&
                          menus[index].msgCount! > 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
//                          borderRadius: BorderRadiusGeometry.lerp(a, b, t)
                        ),
                      ),
                    ),
                    Expanded(child: nullableText(menus[index].info)),
                    Container(
                      margin: const EdgeInsets.only(left: 8,right: 8),
                      width: 12,
                      height: 12,
                      child: Image.asset("images/ic_right_arrow_gary.png"),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: Colors.black12,
              )
            ],
          ),
        );
      },
    );
  }

  static const TextStyle points = TextStyle(
    fontWeight: FontWeight.bold,
      fontSize: 18
  );

  static const TextStyle des = TextStyle(
      color: Colors.grey,
      fontSize: 12
  );
  Widget createHeader(dynamic data) {
//    var pic=data['userpic'];
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
                margin: const EdgeInsets.only(left: 18, top: 24, bottom: 12,right: 12),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(placeHolder(data, 'thumb'))
                )),
            Text(placeHolder(data, 'user_name'),style: const TextStyle(fontSize: 20),)
          ],
        ),
//          Card(
//            margin: const EdgeInsets.only(left: 12,right: 12),
//            child:
        Container(
          padding: const EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(placeHolder(data, 'credit'),style: points,),
                  const Text('学分',style: des,)
                ],
              ),
              Column(
                children: <Widget>[
                  Text(placeHolder(data, 'credit_rank'),style: points,),
                  const Text('积分排行榜',style: des,)
                ],
              ),
              Column(
                children: <Widget>[
                  Text(placeHolder(data, 'favorite_num'),style: points,),
                  const Text('收藏',style: des,)
                ],
              )
            ],
          ),
        ),
//          ),
      ],
    );
  }

  String placeHolder(dynamic data, String key) {
    if (null != data && null != data[key]) {
      return data[key].toString();
    } else {
      return '';
    }
  }

  createBody() {
   if(null!=token&&token!.isNotEmpty){
     return   ListView(
       children: <Widget>[
         FutureBuilder(
           future: post(context,'getMineInfo', formData: {'user_ticket': token}),
           builder: (context, snapshot) {
             if (snapshot.hasData) {
                 var rep = json.decode(snapshot.data.toString());
                 info = rep['data'];
                 return createHeader(info);
             } else {
               return createHeader(null);
             }
           },
         ),
         Container(
           height: 8,
           color: Colors.black12,
         ),
         inflateMenu()
       ],
     );
   }else{
     UiUtil.emptyView('正在加载');
   }

  }
}
