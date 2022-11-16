import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_ykt/ykt/pages/widget/course_learn_item_lv1.dart';
import 'package:flutter_ykt/ykt/service/http_service.dart';
import 'package:flutter_ykt/ykt/pages/state/course_learn_widget.dart';
import 'package:flutter_ykt/ykt/util/ui_util.dart';

// ignore: must_be_immutable
class CourseLearnPage extends StatefulWidget {
  bool isContinue = false;
  bool isAudition = false;
  String cert_id = "";

  CourseLearnPage(
      {super.key, required this.cert_id,
      required this.isContinue,
      required this.isAudition});

  @override
  _CourseLearnPageState createState() => _CourseLearnPageState();
}

class _CourseLearnPageState extends State<CourseLearnPage> {
  final CourseLearnState _data = CourseLearnState(playing_id: "0");


  dynamic playing = null;
  int index = -1;
  int? course_id;
  int? detail_id;
  bool? fullscreen;
  List<dynamic>? lecture;
  late VideoPlayerController _controller;
  String? _token = null;
  String? get token{
    _token ??= context.watch<LoginState>().token;
    return _token;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose(){
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getFuture(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString())['data'];
            lecture = data['lectureInfo'];
            return Column(
              children: [
                AspectRatio(
                    aspectRatio: 16 / 9,
                    child: "0" == _data.playing_id
                        ? Container(
                            color: Colors.green[200],
                          )
                        :
                VideoPlayer(_controller)
                ),
                Expanded(
                    child: CourseLearnStateWidget(
                  data: _data,
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return CourseLearnItemLV1(
                        cert_id: widget.cert_id,
                        index: index,
                        lecture: lecture?[index],
                        itemChildClickListener: (item) {
                          setState(() {
                            _data.playing_id = item['id'];
                            playing = item;
                            _controller = VideoPlayerController.network(playing['mp4_url'])
                              ..initialize().then((_) {
                                setState(() {
                                  _controller.play();
                                });
                              });
                          });
                        },
                      );
                    },
                    itemCount: lecture?.length,
                    shrinkWrap: false,
                  ),
                ))
              ],
            );
          } else {
            return UiUtil.emptyView('加载中');
          }
        },
      ),
    );
  }

  Future<dynamic> getFuture() {
    if (widget.isAudition) {
      return post(context, "getCourseAuditionInfo",
          formData: {'user_ticket': token, 'cert_id': widget.cert_id});
    } else {
      if (widget.isContinue) {
        return post(context, "getCourseContinueInfo",
            formData: {'user_ticket': token, 'cert_id': widget.cert_id});
      } else {
        return post(context, "getCourseLearnInfo",
            formData: {'user_ticket': token, 'cert_id': widget.cert_id});
      }
    }
  }
  autoNext() {}
}
