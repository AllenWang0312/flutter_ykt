import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ykt/common/video/video_player_UI.dart';
import 'package:flutter_ykt/ykt/pages/state/course_learn_widget.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_ykt/ykt/pages/widget/course_learn_item_lv1.dart';
import 'package:flutter_ykt/ykt/service/http_service.dart';
import 'package:flutter_ykt/ykt/util/ui_util.dart';

// ignore: must_be_immutable
class CourseLearnPage extends StatefulWidget {
  bool isContinue = false; //继续播放
  bool isAudition = true; //试看
  String cert_id = "";
  String title = '';
  String url = '';

  CourseLearnPage(this.isContinue, this.isAudition, this.cert_id, {super.key});

  @override
  _CourseLearnPageState createState() => _CourseLearnPageState();
}

class _CourseLearnPageState extends State<CourseLearnPage>
    with UiClickListener {
  _CourseLearnPageState();

  String title = '';
  String url = '';
  String cert_id = '';
  dynamic root;
  int course_index = 0;
  String course_id = '0';
  int lecture_index = 0;
  String lecture_id = '0';
  int playing_index = 0;
  String playing_id = '0';

  dynamic playing = null;

  bool hasNextDetail() {
    return !isLast(getDetails(course_index, lecture_index), playing_index);
  }

  bool hasNextLecture() {
    return !isLast(getLectures(course_index), lecture_index);
  }

  bool hasNextCourse() {
    return !isLast(root, course_index);
  }

  dynamic getCourse(int offset) {
    return root[offset];
  }

  dynamic getLectures(int cof) {
    return getCourse(cof)['courseList'];
  }

  dynamic getLecture(int cof, int lof) {
    return getLectures(cof)[lof];
  }

  dynamic getDetails(int cof, int lof) {
    return getLecture(cof, lof)['detail'];
  }

  dynamic getDetail(int cof, int lof, int dof) {
    return getDetails(cof, lof)[dof];
  }

  int findPosition(dynamic list, String key, String value) {
    if (list is List) {
      for (var i = 0; i < list.length; i++) {
        if (list[i][key] == value) {
          return i;
        }
      }
    }
    return -1;
  }

  bool isLast(dynamic list, int offset) {
    if (list is List) {
      return offset == list.length - 1;
    }
    return false;
  }

  void autoNext() {
    // _controller.pause();
    if (hasNextDetail()) {
      playing_index++;
    } else if (hasNextLecture()) {
      lecture_index++;
      playing_index = 0;
    } else if (hasNextCourse()) {
      course_index++;
      lecture_index = 0;
      playing_index = 0;
    } else {
      // Toast
    }
    playing = getDetails(course_index, lecture_index)[playing_index];
    playing_id = playing['id'];

    // _controller = VideoPlayerController.network(playing['mp4_url'])
    //   ..initialize().then((_) {
    //     setState(() {
    //       _controller.play();
    //     });
    //   });
  }

  late CourseLearnState _data;

  // late VideoPlayerController _controller;
  String? _token;

  String? get token {
    _token ??= context.watch<LoginState>().token;
    return _token;
  }

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(widget.url ?? "");
    // _controller.addListener(() {});
  }

  // void initData() async {
  //   await getFuture().then((snapshot) => {
  //
  //   });
  // }
  @override
  void dispose() {
    super.dispose();
    // _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getFuture(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = json.decode(snapshot.data.toString())['data'];
            root = data['lectureInfo'];
            _data = CourseLearnState(playing_id);
            return CourseLearnStateWidget(
              data: _data,
              child: Column(
                children: [
                  SafeArea(
                    child:
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child:
                      // "0" == playing_id
                      //     ? Container(
                      //         color: Colors.green[200],
                      //       )
                      //     :
                          // VideoPlayer(_controller),
                          VideoPlayerUI.network(
                              url: this.url,
                              height: double.infinity,
                              width: double.infinity,
                              title: this.title),
                      // ControllerWidget(
                      //     controlKey: _key,
                      //     controller: _controller,
                      //     videoInit: _videoInit,
                      //     title: widget.title,
                      //     child: VideoPlayerPan(
                      //       child: Container(
                      //         alignment: Alignment.center,
                      //         width: double.infinity,
                      //         height: double.infinity,
                      //         color: Colors.black,
                      //         child: _isVideoInit(),
                      //       ),
                      //     ),
                      //   )
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return CourseLearnItemLV1(
                          cert_id: widget.cert_id,
                          index: index,
                          lecture: root?[index],
                          itemChildClickListener: (lecture_id, item) {
                            course_index = index;
                            course_id = root?[index]['cert_lecture_id'];
                            // lecture_index = findPosition(list, key, value)
                            this.lecture_id =
                                lecture_id; //lecture?[index][]['course_id'];
                            playing = item;
                            setState(() {
                              title = playing['title'];
                              url = playing['mp4_url'];
                              playing_id = playing['id'];
                              _data.playing_id = playing_id;
                              // player.updateController(_controller);
                            });
                          },
                        );
                      },
                      itemCount: root?.length,
                      shrinkWrap: false,
                    ),
                  ),
                ],
              ),
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

  @override
  void onBackClick() {
    // TODO: implement onBackClick
  }

  @override
  void onFullScreen() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return FullScreenPlayerPage(_controller,
    //       isFullScreen: false);
    // }));
  }

  @override
  void onLastClick() {}

  @override
  void onNextClick() {
    setState(() {
      autoNext();
    });
  }

  @override
  void onQuitFullScreen() {
    Navigator.pop(context);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}

abstract class UiClickListener {
  void onBackClick();

  void onLastClick();

  void onNextClick();

  void onFullScreen();

  void onQuitFullScreen();
}
