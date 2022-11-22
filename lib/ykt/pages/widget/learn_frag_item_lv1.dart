import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/config/color.dart';
import 'package:flutter_ykt/ykt/pages/course_learn_page.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:flutter_ykt/ykt/util/dynamic_util.dart';
import 'package:flutter_ykt/ykt/util/time_util.dart';
import 'package:provider/provider.dart';

class LearnFragItemLV1 extends StatelessWidget {
  int index;
  String cert_id;
  int last_learn_course_id;

  dynamic lecture;

  LearnFragItemLV1(
      {required this.index, required this.cert_id, required this.last_learn_course_id, this.lecture});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: [
          Container(
            color: Colors.blue,
            margin: const EdgeInsets.only(right: 8),
            width: 4,
            height: 16,
          ),
          Text(
            "第${index + 1}讲:" + (lecture[index]['name']??""),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(
                color: KColor.black44,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        ]),
        courseList(context, index, lecture[index]['courseList']),
      ],
    );
  }

  Widget courseList(BuildContext context, int index, List<dynamic> courseList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: courseList
          .map((item) => InkWell(
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MultiProvider(providers: [ChangeNotifierProvider(create: (_) => LoginState())],
                    child:CourseLearnPage( false, false,cert_id
                    ));
                  }))
                },
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  // decoration: ,
                  child: Row(
                    //lecture item
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 12),
                        child: Text(
                          '${index + 1}-${courseList.indexOf(item) + 1}',
                          style: const TextStyle(fontSize: 16, color: KColor.garyA1),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: KColor.black30),
                            ),
                            _getSubInfo(item),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: item['course_id'] == last_learn_course_id,
                          child: Container(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 2),
                            height: 24,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(12)),
                                border: Border.all(
                                  width: 1,
                                  color: KColor.primaryColor,
                                  style: BorderStyle.solid,
                                )),
                            child: const Text(
                              '继续学习',
                              style: TextStyle(
                                  color: KColor.primaryColor, fontSize: 12),
                            ),
                          ))
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _getSubInfo(item) {
    var style = const TextStyle(fontSize: 12, color: KColor.garyA1);
    if (null == item['learn_rate']) {
      return Text(
        TimeUtil.durationTransform(Util.safeGetInt(item, 'video_duration')),
        style: style,
      );
    } else {
      return Text(
        '${item['video_duration']}已学${item['learn_rate']}%',
        style: style,
      );
    }
  }
}
