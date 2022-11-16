import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/config/color.dart';
import 'package:flutter_ykt/ykt/pages/course_learn_page.dart';
import 'package:flutter_ykt/ykt/pages/state/course_learn_widget.dart';
import 'package:flutter_ykt/ykt/util/time_util.dart';


class CourseLearnItemLV1 extends StatefulWidget {
  int index;
  String cert_id;

  Function itemChildClickListener;
  dynamic lecture;

  CourseLearnItemLV1(
      {required this.index, required this.cert_id, this.lecture, required this.itemChildClickListener});

  @override
  State<StatefulWidget> createState() {
    return LectureState();
  }
}

class LectureState extends State<CourseLearnItemLV1> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //章
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
          Container(
            color: Colors.blue,
            margin: EdgeInsets.only(right: 8),
            width: 4,
            height: 16,
          ),
          Text(
            "第${widget.index + 1}讲:" + widget.lecture['name'],
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
                color: KColor.black44,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ]),
        _courseLearnItemLV2(context, widget.index, widget.lecture['courseList'],
            widget.itemChildClickListener),
      ],
    );
  }


  Widget _courseLearnItemLV2(BuildContext context, int index, List<dynamic> courseList,
      Function itemChildClickListener) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: courseList
          .map((item) => InkWell(
                onTap: () => {
                  // setState(() {
                  //   if (CourseLearnStateScope.of(context).expand_id ==
                  //       item['course_id']) {
                  //     setState(() {
                  //       CourseLearnStateScope.of(context).update(expand_id:"0" );
                  //     });
                  //
                  //   } else {
                  //    setState(() {
                  //      CourseLearnStateScope.of(context).update(expand_id: item['course_id']);
                  //    });
                  //   }
                  // })
                },
                child: _courseItem(item, index, courseList.indexOf(item),
                    itemChildClickListener),
              ))
          .toList(),
    );
  }

  Widget _courseItem(item, int index, int subIndex, Function childClick) {
    List<dynamic> details = item['detail'];
    var itemExtent=(MediaQuery.of(context).size.width-48)/2.5;
    return Column(
      // decoration: ,
      children: [
        _courseTitle('${index + 1}-${subIndex + 1}', item['title']),
        Container(
          margin: EdgeInsets.fromLTRB(24, 8, 24, 0),
          height: 60,
          // padding: EdgeInsets.fromLTRB(24, 0, 24, 4),
          child: ListView.builder(
            itemExtent: itemExtent,
            //强制item大小 便于listview 滑动预判
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(bottom: 14),
            itemBuilder: (context, index) {
              dynamic item = details[index];
              print(item);
              return InkWell(//course_learn_item_lv3
                onTap: () {
                  childClick.call(item);
                },
                child: detail(item['title'], item['id']),
              );
            },
            itemCount: details.length,
          ),
        )
      ],
    );
  }

  Widget _courseTitle(String order, String title) {
    return Row(
        //lecture item
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              order,
              style: TextStyle(fontSize: 15, color: KColor.garyA1),
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: KColor.black30),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget detail(String title, String id) {
    return Container(
      padding: EdgeInsets.only(left: 4, right: 4),
      margin: EdgeInsets.only(left: 4, right: 4),
      decoration: BoxDecoration(
        color: CourseLearnStateWidget.of(context).playing_id == id
            ? Colors.blue[200]
            : Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(fontSize: 14),
        maxLines: 2,
      ),
    );
  }
}
