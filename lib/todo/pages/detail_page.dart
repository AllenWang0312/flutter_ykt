import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ykt/common/widgets/icon_wrapper.dart';

import '../model/stract/Item.dart';

class DetailPage extends StatefulWidget {
  String groupName;
  Item item;

  DetailPage(this.groupName, this.item);

  @override
  State<StatefulWidget> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Item data;
  List<dynamic>? step;
  List<dynamic>? done;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    String str = await DefaultAssetBundle.of(context).loadString(
        "assets/debug/item_info" + widget.item.id.toString() + ".json");
    setState(() {
      data = Item.fromJson(json.decode(str));
      step = data.step;
      done = data.done;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back),
        ),
        title: Text(widget.groupName),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Row(
              children: [
                Container(
                    height: 36,
                    width: 36,
                    margin: EdgeInsets.all(8),
                    child: Icon(Icons.done)),
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: TextStyle(fontSize: 32),
                  ),
                ),
                IconWrapper(48, Icons.star, () => null)
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: getChildren(),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
          Row(
            children: [
              Expanded(child: Text("    创建于7小时前")),
              Container(
                  width: 36,
                  height: 36,
                  margin: EdgeInsets.all(8),
                  child: InkWell(child: Icon(Icons.delete)))
            ],
          )
        ],
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> result = [];
    if (null != step) {
      for (int i = 0; i < step!.length; i++) {
        result.add(SizedBox(
          height: 48,
          child: Row(
            children: [Icon(Icons.question_mark), Text(step![i])],
          ),
        ));
      }
    }
    if (null != done) {
      for (int i = 0; i < done!.length; i++) {
        result.add(SizedBox(
          height: 48,
          child: Row(
            children: [
              Icon(Icons.done),
              Text(
                done![i],
                style: TextStyle(decoration: TextDecoration.lineThrough),
              )
            ],
          ),
        ));
      }
    }
    TextEditingController controller = TextEditingController();
    result.add(InkWell(
      onTap: () {},
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 16),
            width: 48,
            height: 48,
            child: Icon(
              Icons.add,
              color: Colors.blue,
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onEditingComplete: () {
                print(controller.text);
              },
              maxLength: 30,
              maxLines: 1,
              decoration: InputDecoration(border: null),
              style: const TextStyle(fontSize: 16),
              textInputAction: TextInputAction.done,
            ),
          )
        ],
      ),
    ));

    result.add(Divider(
      height: 4,
    ));
    result.add(
      Row(
        children: [
          SizedBox(height: 48, width: 48, child: Icon(Icons.sunny)),
          Text("添加到 \"我的一天\"")
        ],
      ),
    );
    result.add(Divider(
      height: 4,
    ));
    result.add(
      Row(
        children: [
          SizedBox(
              height: 48, width: 48, child: Icon(Icons.notifications_outlined)),
          Text("提醒我")
        ],
      ),
    );
    result.add(Divider(
      indent: 48,
      height: 2,
      color: Colors.grey,
    ));

    result.add(Divider(
      height: 4,
    ));
    result.add(
      Row(
        children: [
          SizedBox(height: 48, width: 48, child: Icon(Icons.attach_file)),
          Text("添加文件")
        ],
      ),
    );
    result.add(Divider(
      height: 4,
    ));

    result.add(Container(
      height: 200,
      padding: EdgeInsets.all(8),
      child: Text("添加备注"),
    ));

    return result;
  }
}
