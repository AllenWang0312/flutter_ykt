import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ykt/common/widgets/banner.dart';
import 'package:flutter_ykt/common/widgets/custom_appbar.dart';
import 'package:flutter_ykt/ykt/pages/cert_detial.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../config/index.dart';
import '../../service/http_service.dart';
import '../../config/color.dart';

class HomePage extends StatefulWidget {
  int? class_id = 0;
  String? class_name;

  HomePage({super.key, this.class_id, this.class_name});

  Future<int?> getClassId() async {
    if (class_id == 0) {
      SharedPreferences sp = await SharedPreferences.getInstance();
      class_id = sp.getInt('class_id');
    }
    return class_id;
  }

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;
  late TabController mController;

  String currentTitle = '';
  int selectIndex = 0;
  late List<dynamic> tabs;

  // List<dynamic> list;

  bool isChangging = false;
  Map<int, Widget> widgetCache = Map();
  Map<int,List<dynamic>> dataCache = Map();

  String? _token;

  String? get token{
    _token ??= context.watch<LoginState>().token;
    return _token;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: CustomAppbar(
          title: currentTitle,
          trailingWidget: InkWell(
            child: const Text("更多",
                style: TextStyle(fontSize: 14, color: Colors.black38)),
            onTap: () {
              openNativeWebView(KString.MORE);
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return WebViewPage(title: '更多', url: KString.MORE);
              // }));
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            FutureBuilder(
              future: get(context, 'getBannerData', formData: {"type": 2}),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = json.decode(snapshot.data.toString());
                  List<Map> banners = (data['data'] as List).cast();
                  return BannerView(banners);
                } else {
                  return const SizedBox(
                    height: 180,
                    child: Text('加载中...'),
                  );
                }
              },
            ),
            FutureBuilder(
                // initialData: () {
                //   setState(() {
                //     selectIndex = findIndex(data, widget.class_id);
                //     widget.class_id = int.parse(data[selectIndex]['id']);
                //   });
                // },
                future: post(context, "getClasses",
                    formData: {'user_ticket': token}),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    tabs = json.decode(snapshot.data.toString())['data'];
                    widget.class_id = int.parse(tabs[selectIndex]['id']);
                    mController = TabController(
                      initialIndex: selectIndex,
                      length: tabs.length,
                      vsync: this,
                    );
                    mController.addListener(() {
                      if(isChangging){
                        print("ui is changging");
                      }else{
                        setState(() {
                          selectIndex = mController.index;
                          currentTitle = tabs[selectIndex]['name'];
                          widget.class_id = int.parse(tabs[selectIndex]['id']);
                        });
                        saveClassId(widget.class_id!);
                      }
                    });

                    return Column(
                      children: [
                        TabBar(
                          isScrollable: true,
                          indicatorColor: KColor.black30,
                          labelColor: KColor.black30,
                          unselectedLabelColor: KColor.garyA1,
                          indicator: const UnderlineTabIndicator(),
                          controller: mController,
                          tabs: tabs
                              .map((item) => Tab(text: item['name']))
                              .toList(),
                        ),
                        classList(selectIndex)
                        // PageView.builder(
                        //     itemCount:tabs.length,
                        //     onPageChanged:(index){
                        //       onPageChange(index);
                        //     },
                        //     itemBuilder: (BuildContext context,int index){
                        //   return classList(index);
                        // })
                      ],
                    );
                  } else {
                    return const Text('加载中');
                  }
                }),
          ],
        ));
  }

  Widget classItem(Map<dynamic, dynamic> item) {
    return IntrinsicHeight(
        child: InkWell(
      onTap: () {
        var cert_id = item['id'];
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CertDetailPage(cert_id);
        }));
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CachedNetworkImage(imageUrl: item['m_picture']),
            Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2),
                child: Text(
                  item['name'],
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Text(
              item['tag'].toString().replaceAll("、", " | "),
              style: const TextStyle(fontSize: 14, color: KColor.garyA1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${item['chapter']}课${item['lecture']}讲"),
                Text("${item['enroll']}人购买")
              ],
            )
          ],
        ),
      ),
    ));
  }

  void saveClassId(int class_id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('class_id', class_id);
  }

  int findIndex(List<dynamic> data, int class_id) {
    for (var i = 0; i < data.length; i++) {
      if (data[i]['class_id'] == class_id) {
        selectIndex = i;
        return i;
      }
    }
    return 0;
  }

//   Widget classList(List<dynamic> list) {
//     return ListView.builder(
//       itemBuilder: (context, index) {
//         return classItem(list[index])
// //                    Text(list[index]['name'])
//             ;
//       },
//       itemCount: null == list ? 0 : list?.length,
//       shrinkWrap: true, //height warp
//       physics: const NeverScrollableScrollPhysics(), //禁止滑动
//     );
//   }
  Widget classListWithCache(int index) {
    int class_id = int.parse(tabs[index]['id']);
    if (widgetCache.keys.contains(class_id)) {
      return widgetCache[class_id]!;
    } else {
      return FutureBuilder(
          future:
              post(context, 'getClassList', formData: {"class_id": class_id}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list =
                  json.decode(snapshot.data.toString())['data'];
              widgetCache.putIfAbsent(
                  class_id,
                  () =>courseList(list));
              return widgetCache[class_id]!;
            } else {
              return const Text("加载中");
            }
          });
    }
  }

  Widget classListDataCache(int index) {
    isChangging = true;
    int class_id = int.parse(tabs[index]['id']);
    if (dataCache.keys.contains(class_id)) {
      return courseList(dataCache[class_id]!);
    } else {
      return FutureBuilder(
          future:
          post(context, 'getClassList', formData: {"class_id": class_id}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list =
              json.decode(snapshot.data.toString())['data'];
              widgetCache.putIfAbsent(
                  class_id,
                      () =>
                      courseList(list)
              );
              return widgetCache[class_id]!;
            } else {
              return const Text("加载中");
            }
          });
    }
  }

  Widget classList(int index) {
    int class_id = int.parse(tabs[index]['id']);
    return FutureBuilder(
          future:
          post(context, 'getClassList', formData: {"class_id": class_id}),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> list =
              json.decode(snapshot.data.toString())['data'];
                     return courseList(list);
            } else {
              return const Text("加载中");
            }
          });
    }

  Widget courseList(List list) {
    Widget result = ListView.builder(
      itemBuilder: (context, index) {
        return classItem(list[index])
//                    Text(list[index]['name'])
            ;
      },
      itemCount: null == list ? 0 : list.length,
      shrinkWrap: true, //height warp
      physics: const NeverScrollableScrollPhysics(), //禁止滑动
    );
    isChangging =false;
    return result;
  }
  static const platform = const MethodChannel('flutter.open.native.page');
  Future<Null> openNativeWebView(String url) async {
    final String result = await platform.invokeMethod("edu.tjrac.swant.WebActivity",{'url':url});
  }

// Future<void> initList() async {
//   Future<dynamic> snapshot = await post(context, 'getClassList',
//       formData: {"class_id": widget.class_id});
//   setState(() {
//     list = json.decode(snapshot.toString())['data'];
//   });
// }
}
