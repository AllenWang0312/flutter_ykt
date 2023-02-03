import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ykt/common/after_layout.dart';
import 'package:flutter_ykt/common/widgets/custom_appbar.dart';
import 'package:flutter_ykt/common/widgets/custom_dialog.dart';
import 'package:flutter_ykt/todo/pages/custom_todo_detail_page.dart';
import 'package:flutter_ykt/todo/model/stract/group.dart';
import 'package:flutter_ykt/common/util/StringUtil.dart';
import '../model/TodoHomeData.dart';
import '../model/stract/Userinfo.dart';

class TodoMenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodoMenuState();
  }
}

class _TodoMenuState extends State<TodoMenuPage> with AfterLayoutMixin{
  bool expend = false;

  @override
  void initState() {
    super.initState();
  }


  @override
  void afterFirstLayout(BuildContext context) {
    initData(context);
  }

  Future<void> initData(BuildContext context) async {
    String str = await DefaultAssetBundle.of(context)
        .loadString("assets/debug/todo_home_info.json");
    setState(() {
      TodoHomeData data = TodoHomeData.fromJson(json.decode(str));
      personal = data.personal;
      def = data.def;
      userinfo = data.userinfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: userinfo == null
            ? null
            : InkWell(
                onTap: () {
                  setState(() {
                    expend = !expend;
                  });
                },
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      margin: EdgeInsets.only(right: 8),
                      color: Colors.grey,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              userinfo!.name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            // AnimatedRotation(
                            //   turns: null,
                            //   duration: Duration(microseconds: 500),
                            //   child: Icon(Icons.expand_more),
                            // )
                            Icon(Icons.expand_more)
                          ],
                        ),
                        Text(
                          userinfo!.account,
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
        trailingWidget: Icon(Icons.search),
      ),
      // AppBar(
      //   leading: userinfo == null
      //       ? null
      //       : Container(
      //           width: 36,
      //           height: 36,
      //           color: Colors.grey,
      //         ),
      //   title: userinfo == null
      //       ? null
      //       : Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             Text(
      //               userinfo!.name,
      //               style: Theme.of(context).textTheme.titleSmall,
      //             ),
      //             Text(
      //               userinfo!.account,
      //               style: Theme.of(context).textTheme.titleSmall,
      //             )
      //           ],
      //         ),
      //   actions: const [
      //     SizedBox(
      //       height: 36,
      //       width: 36,
      //       child: InkWell(
      //         child: Icon(Icons.search),
      //       ),
      //     )
      //   ],
      // ),
      body: _createBody(),
    );
  }

  Widget _createAppBar() {
    return Row(
      children: [
        Image.network(""),
        Column(
          children: [Text("Coco程"), Text("1007991483@qq.com")],
        ),
        Icon(Icons.more_vert)
      ],
    );
  }

  // TodoHomeData? data;
  Userinfo? userinfo;
  List<Group>? personal;
  List<Group>? def;

  Widget _createBody() {
    if (def != null && personal != null && personal!.isNotEmpty) {
      return _createPersonalTask();
    } else {
      return CircularProgressIndicator();
    }
    // _emoJiList();
  }

  Widget _createPersonalTask() {
    return Column(
      children: [
        Expanded(
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                Group item = personal!.removeAt(oldIndex);
                personal!.insert(newIndex, item);
                // ArrayUtil.reorder<Personal>(data.personal!,oldIndex,newIndex);
              });
            },
            header: Column(
              children:
              _createDefaultTask(),
            ),
            children: [
              for (int i = 0; i < personal!.length; i++)
                SizedBox(
                  key: ValueKey(personal![i].id),
                  height: 48,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      Expanded(
                        child: Text(
                          personal![i].name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Text(TextUtil.fromNullableInt(personal![i].count))
                    ],
                  ),
                )
            ],
          ),
        ),
        _createBottom()
      ],
    );
  }

  List<Widget> _createDefaultTask() {
    List<Widget> result = [];
    for (int i = 0;i<def!.length;i++){
      Group element = def![i];
      result.add(
          Container(
            height: 48,
            padding: const EdgeInsets.only(left: 4, right: 4),
            child: InkWell(
              onTap: () async {
                var result = await Navigator.push(context,  MaterialPageRoute(builder: (context) {
                  return TodoDetailPage(element);
                }));
                if(null!=result&&element != result){
                  setState(() {
                    def!.removeAt(i);
                    def!.insert(i, result);
                  });
                }
              },
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  Expanded(
                    child: Text(element.name),
                  ),
                  Text(TextUtil.fromNullableInt(element.count))
                ],
              ),
            ),
          )
      );
    }
    result.add(const Divider(
      height: 2,
      color: Colors.grey,
    ));
    return result;
  }

  Widget _createBottom() {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Icon(Icons.add),
          Expanded(
            child: Text("新建列表"),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext contenxt) {
                    var controller = TextEditingController();
                    return CustomCupertinoDialog(
                        title: "创建组",
                        // content: TextField(
                        //   controller: controller,
                        //   maxLength: 30,
                        //   maxLines: 1,
                        //   autofocus: true,
                        //   style: const TextStyle(fontSize: 16),
                        // ),
                        callback: (content){
                          print(content);
                        });
                  });
            },
            child: Icon(Icons.add_box_outlined),
          )
        ],
      ),
    );
  }

}
