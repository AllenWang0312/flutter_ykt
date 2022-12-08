import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ykt/common/util/array_util.dart';
import 'package:flutter_ykt/common/widgets/icon_wrapper.dart';
import 'package:flutter_ykt/todo/model/GroupDetail.dart';
import 'package:flutter_ykt/todo/pages/detail_page.dart';

import '../model/stract/Item.dart';
import '../model/stract/group.dart';

class TodoDetailPage extends StatefulWidget {
  Group info;

  TodoDetailPage(this.info);

  @override
  State<StatefulWidget> createState() {
    return _TodoDetailState();
  }
}

class _TodoDetailState extends State<TodoDetailPage> {
  bool hasSelected = false;
  bool expend = false;
  List<Item>? items;
  List<Item>? finished;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    String str = await DefaultAssetBundle.of(context).loadString(
        "assets/debug/todo_group_task" + widget.info.id.toString() + ".json");
    setState(() {
      GroupDetail data = GroupDetail.fromJson(json.decode(str));
      items = data.items;
      finished = data.finished;
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = (widget.info.icon != null
        ? String.fromCharCode(widget.info.icon!)
        : "") +
        widget.info.name;
    return Scaffold(
      appBar: hasSelected
          ? AppBar()
          : AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text(title),
        actions: [
          IconWrapper(36, Icons.person_add_alt_outlined, () => null,margin: EdgeInsets.only(right: 8),),
          IconWrapper(36,  Icons.more_vert, () => null,margin: EdgeInsets.only(right: 8),)
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(true as FutureOr<void> Function());
        },
        child: createList(items, finished),
      ),
      floatingActionButton: Icon(Icons.add),
    );
  }

  Item getItem(int index) {
    int itemSize = ArrayUtil.nullableListSize(items);
    late Item item;
    if (index > itemSize) {
      item = finished![index - itemSize - 1];
    } else if (index < itemSize) {
      item = items![index];
    }
    return item;
  }

  Widget createItem(int index) {
    Item item = getItem(index);
    return Container(
      padding: EdgeInsets.all(4),
      child: Card(
        child: SizedBox(
          height: 48,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) => DetailPage(widget.info.name, item)));
            },
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie.asset("")
                Container(
                    margin: EdgeInsets.only(left: 8, right: 8),
                    height: 36,
                    width: 36,
                    child: InkWell(
                      onTap: () => switchItemDone(index),
                      child: Icon((null != item.finished && item.finished!)
                          ? Icons.done
                          : Icons.question_mark),
                    )),
                Expanded(
                  child: item.onlyHead()
                      ? Text(item.name, style: TextStyle(fontSize: 16))
                      : Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: createTitleSubTitle(item),
                  ),
                ),
                Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.only(right: 8),
                  child: InkWell(
                      onTap: () {
                        // print("switch star");
                        // setState(() {
                        //   item.star=!item.star;
                        // });
                      },
                      child: Icon(item.star ? Icons.star : Icons.star_border)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> createTitleSubTitle(Item item) {
    List<Widget> result = [];
    result.add(Text(
      item.name,
      style: TextStyle(fontSize: 16),
    ));
    if (null != item.steps && item.steps! > 0) {
      result.add(Text(
        "第${item.hasDoneStep}步，共${item.steps}步",
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ));
    } else if (null != item.hasText) {
      result.add(Icon(Icons.file_copy_outlined));
    } else if (null != item.data) {
      result.add(Text(
        item.data.toString(),
        style: TextStyle(fontSize: 12, color: Colors.red),
      ));
    } else if (null != item.targetGroupName) {
      result.add(Text(item.targetGroupName!));
    }
    return result;
  }

  switchItemDone(int index) {
    Item item = getItem(index);
    item.finished ??= false;
    item.finished = !item.finished!;
    setState(() {
      if (item.finished!) {
        items?.removeAt(index);
        finished ??= [];
        finished!.insert(0, item);
      } else {
        finished?.remove(item);
        items ??= [];
        items!.add(item);
      }
    });
  }

  Widget createList(List<Item>? items, List<Item>? finished) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        if (index == ArrayUtil.nullableListSize(items)) {
          return SizedBox(
            height: 48,
            child: InkWell(
              onTap: () {
                setState(() {
                  expend = !expend;
                });
              },
              child: Row(
                children: [
                  Icon(expend ? Icons.expand_more : Icons.chevron_right),
                  Text(
                      " 已完成 " + ArrayUtil.nullableListSize(finished).toString())
                ],
              ),
            ),
          );
        } else {
          return createItem(index);
        }
      },
      itemCount: ArrayUtil.nullableListSize(finished) == 0
          ? ArrayUtil.nullableListSize(items)
          : expend
          ? ArrayUtil.nullableListSize(items) +
          1 +
          ArrayUtil.nullableListSize(finished)
          : ArrayUtil.nullableListSize(items) + 1,
    );
  }

// _emoJiList() {
//   return FutureBuilder(
//       future: DefaultAssetBundle.of(context).loadString("assets/emoji.json"),
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           List<dynamic> data = json.decode(snapshot.data.toString());
//           return Stack(
//             children: <Widget>[
//               Container(
//                 height: 200,
//                 padding: const EdgeInsets.only(
//                     left: 5, top: 5, right: 5, bottom: 5),
//                 color: Colors.white,
//                 child: GridView.custom(
//                   padding: EdgeInsets.all(3),
//                   shrinkWrap: true,
//                   gridDelegate:
//                       const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 6,
//                     mainAxisSpacing: 0.5,
//                     crossAxisSpacing: 6.0,
//                   ),
//                   childrenDelegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           // _inputString = _inputString +
//                           //     String.fromCharCode(data[index]["unicode"]);
//                           // setState(() {});
//                         },
//                         child: Center(
//                           child: Text(
//                             String.fromCharCode(data[index]["unicode"]),
//                             style: const TextStyle(fontSize: 33),
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: data.length,
//                   ),
//                 ),
//               ),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Text("decode json file error: " + snapshot.error.toString());
//         }
//         return const CircularProgressIndicator();
//       });
// }
}
