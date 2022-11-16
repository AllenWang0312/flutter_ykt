import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/state/course_learn_widget.dart';
import 'package:video_player/video_player.dart';

class MyMediaPlayer extends StatefulWidget {
  const MyMediaPlayer({Key? key}) : super(key: key);

  @override
  MyMediaPlayerState createState() => MyMediaPlayerState();
}

class MyMediaPlayerState extends State<MyMediaPlayer> {
  bool isPlaying = false;
  String title = "";
  String url = "";

  static MyMediaPlayerState of(BuildContext context) {
    return context.findAncestorStateOfType<MyMediaPlayerState>()!;
  }

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(url);
    player = VideoPlayer(controller!);
  }
  VideoPlayerController? controller;

  late VideoPlayer player;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        player,
        SafeArea(
            child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Expanded(
                      child: Text(
                    title,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )),
                  const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(Icons.more_vert, color: Colors.white))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () {
                        if (isPlaying) {
                          controller?.pause();
                          setState(() {
                            isPlaying = false;
                          });
                        } else {
                          controller?.play();
                          setState(() {
                            isPlaying = true;
                          });
                        }
                      },
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.skip_next,
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                      ))
                ],
              ),
            )
          ],
        ))
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  void play(String url, String title) {
    setState(() {
      this.url = url;
      this.title = title;
      controller = VideoPlayerController.network(url)
        ..initialize().then((_) {
          controller?.play();
        });
      player = VideoPlayer(controller!);
    });

  }
}
