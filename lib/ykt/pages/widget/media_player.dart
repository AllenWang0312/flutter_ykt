import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ykt/ykt/pages/course_learn_page.dart';
import 'package:flutter_ykt/ykt/pages/widget/fullscreen_player_page.dart';
import 'package:video_player/video_player.dart';

const int UI_BACK = 0;
const int UI_LAST = 1;
const int UI_NEXT = 2;
const int UI_FULLSCREEN = 3;
const int UI_QUIT_FULLSCREEN = 4;

class MyMediaPlayer extends StatefulWidget {
  Widget child;
  // UiClickListener? uiClickListener;
  Function? fullScreenCallback;
  Function? nextCallback;
  Function? lastCallback;
  Function? backCallback;

  bool? isFullScreen = false;
  bool isPlaying = true;
  String? title = "";
  String? url = "";

  MyMediaPlayer(this.child,
      {this.title, this.url,
        // this.uiClickListener,
        this.lastCallback,
        this.nextCallback,
        this.fullScreenCallback,
        this.isFullScreen});

  @override
  MyMediaPlayerState createState() => MyMediaPlayerState();
}

class MyMediaPlayerState extends State<MyMediaPlayer> {
  MyMediaPlayerState();

  @override
  Widget build(BuildContext context) {
    return widget.child;
    // Stack(
    //   children: [
    //     widget.child,
    //     Stack(
    //       children: [
    //         Align(
    //           alignment: Alignment.topCenter,
    //           child: Row(
    //             children: [
    //               const SizedBox(
    //                   width: 48,
    //                   height: 48,
    //                   child: Icon(
    //                     Icons.arrow_back,
    //                     color: Colors.white,
    //                   )),
    //               Expanded(
    //                   child: Text(
    //                     widget.title??"",
    //                     style: const TextStyle(
    //                         fontSize: 16, color: Colors.white),
    //                   )),
    //               const SizedBox(
    //                   width: 48,
    //                   height: 48,
    //                   child: Icon(Icons.more_vert, color: Colors.white))
    //             ],
    //           ),
    //         ),
    //         Align(
    //           alignment: Alignment.bottomCenter,
    //           child: Row(
    //             children: [
    //               SizedBox(
    //                 width: 36,
    //                 height: 36,
    //                 child: InkWell(
    //                   onTap: () {
    //                     widget.lastCallback?.call();
    //                   },
    //                   child: const Icon(
    //                     Icons.chevron_left_outlined,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 48,
    //                 height: 48,
    //                 child: InkWell(
    //                   onTap: () {
    //                     if (widget.isPlaying) {
    //                       widget.controller?.pause();
    //                       setState(() {
    //                         widget.isPlaying = false;
    //                       });
    //                     } else {
    //                       widget.controller?.play();
    //                       setState(() {
    //                         widget.isPlaying = true;
    //                       });
    //                     }
    //                   },
    //                   child: Icon(
    //                     widget.isPlaying ? Icons.pause : Icons.play_arrow,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(
    //                 width: 36,
    //                 height: 36,
    //                 child: InkWell(
    //                   onTap: () {
    //                     widget.nextCallback?.call();
    //                   },
    //                   child: const Icon(
    //                     Icons.chevron_right_outlined,
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               ),
    //               Expanded(
    //                 child: VideoProgressIndicator(
    //                   widget.controller,
    //                   allowScrubbing: true,
    //                 ),
    //               ),
    //               SizedBox(
    //                   width: 36,
    //                   height: 36,
    //                   child: InkWell(
    //                     onTap: () {
    //                       // if (null!=widget.isFullScreen&&widget.isFullScreen!) {
    //                       //   uiClickListener?.onQuitFullScreen();
    //                       // } else {
    //                         widget.fullScreenCallback?.call();
    //                       // }
    //                     },
    //                     child: getFullScreenIcon(widget.isFullScreen),
    //                   ))
    //             ],
    //           ),
    //         )
    //       ],
    //     )
    //   ],
    // );
  }
  @override
  void dispose() {
    if(null!=widget.isFullScreen&&widget.isFullScreen!){
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    super.dispose();
  }

  Widget getFullScreenIcon(bool? isFullScreen) {
    if (null != isFullScreen && isFullScreen!) {
      return const Icon(
        Icons.fullscreen_exit,
        color: Colors.white,
      );
    }
    return const Icon(
      Icons.fullscreen,
      color: Colors.white,
    );
  }
}
