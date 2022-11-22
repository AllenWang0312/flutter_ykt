import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

// import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'controller_widget.dart';
import 'video_player_control.dart';
import 'video_player_pan.dart';

enum VideoPlayerType { network, asset, file }

class VideoPlayerUI extends StatefulWidget {
  VideoPlayerUI.network({
    required String url, // 当前需要播放的地址
    this.width: double.infinity, // 播放器尺寸（大于等于视频播放区域）
    this.height: double.infinity,
    this.title = '', // 视频需要显示的标题
  })  : type = VideoPlayerType.network,
        url = url;

  VideoPlayerUI.asset({
    required String dataSource, // 当前需要播放的地址
    this.width: double.infinity, // 播放器尺寸（大于等于视频播放区域）
    this.height: double.infinity,
    this.title = '', // 视频需要显示的标题
  })  : type = VideoPlayerType.asset,
        url = dataSource;

  VideoPlayerUI.file({
    required File file, // 当前需要播放的地址
    this.width: double.infinity, // 播放器尺寸（大于等于视频播放区域）
    this.height: double.infinity,
    this.title = '', // 视频需要显示的标题
  })  : type = VideoPlayerType.file,
        url = file;

  final dynamic url;
  final VideoPlayerType type;
  final double width;
  final double height;
  final String title;

  @override
  _VideoPlayerUIState createState() => _VideoPlayerUIState();
}

class _VideoPlayerUIState extends State<VideoPlayerUI> {
  final GlobalKey<VideoPlayerControlState> _key =
      GlobalKey<VideoPlayerControlState>();

  ///指示video资源是否加载完成，加载完成后会获得总时长和视频长宽比等信息
  bool _videoInit = false;
  bool _videoError = true;

  late VideoPlayerController _controller; // video控件管理器

  bool _isFullScreen = false;
  /// 记录是否全屏
  bool get isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  @override
  void initState() {
    super.initState();

    _urlChange(); // 初始进行一次url加载
    // Screen.keepOn(true); // 设置屏幕常亮
  }

  @override
  void didUpdateWidget(VideoPlayerUI oldWidget) {
    print('didupdatwidget:old'+oldWidget.width.toString() +":"+ oldWidget.height.toString() );
    print('didupdatwidget:new'+widget.width.toString() +":"+ widget.height.toString() );

    if (oldWidget.url != widget.url) {
      _urlChange(); // url变化时重新执行一次url加载
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() async {
    super.dispose();
    if (_controller != null) {
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    // Screen.keepOn(false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !isFullScreen,
      bottom: !isFullScreen,
      left: !isFullScreen,
      right: !isFullScreen,
      child: Container(
        width: isFullScreen ? _window.width : widget.width,
        height: isFullScreen ? _window.height : widget.height,
        child: _isHadUrl(),
      ),
    );
  }

// 判断是否有url
  Widget _isHadUrl() {
    if (widget.url != null) {
      return ControllerWidget(
        controlKey: _key,
        controller: _controller,
        videoInit: _videoInit,
        title: widget.title,
        child: VideoPlayerPan(
          child: Container(
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            color: Colors.black,
            child: _isVideoInit(isFullScreen),
          ),
        ),
      );
    } else {
      return const Center(
        child: Text(
          '暂无视频信息',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

// 加载url成功时，根据视频比例渲染播放器
  Widget _isVideoInit(bool isFullScreen) {
    if (_videoInit) {
      return !isFullScreen?VideoPlayer(_controller)
      :SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child:VideoPlayer(_controller));;


    } else if (_controller != null && _videoError) {
      return const Text(
        '请选择要播放的文件',
        style: TextStyle(color: Colors.white),
      );
    } else {
      return const SizedBox(
        width: 30,
        height: 30,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }
  }

  void _urlChange() async {
    if (widget.url == null) {
      return;
    }
    if (widget.url == '') {
      _controller = VideoPlayerController.network(widget.url);
      return;
    }
    if (_controller != null) {
      /// 如果控制器存在，清理掉重新创建
      _controller.removeListener(_videoListener);
      _controller.dispose();
    }
    setState(() {
      /// 重置组件参数
      _videoInit = false;
      _videoError = false;
    });
    if (widget.type == VideoPlayerType.file) {
      _controller = VideoPlayerController.file(widget.url);
    } else if (widget.type == VideoPlayerType.asset) {
      _controller = VideoPlayerController.asset(widget.url);
    } else {
      _controller = VideoPlayerController.network(widget.url);
    }

    /// 加载资源完成时，监听播放进度，并且标记_videoInit=true加载完成
    _controller.addListener(_videoListener);
    await _controller.initialize();
    setState(() {
      _videoInit = true;
      _videoError = false;
      _controller.play();
    });
  }

  void _videoListener() async {
    if (_controller.value.hasError) {
      setState(() {
        _videoError = true;
      });
    } else {
      Duration? res = await _controller.position;
      if (null != res && res >= _controller.value.duration) {
        await _controller.seekTo(Duration(seconds: 0));
        await _controller.pause();
      }
      if (_controller.value.isPlaying && _key.currentState != null) {
        /// 减少build次数
        _key.currentState?.setPosition(
          position: res,
          totalDuration: _controller.value.duration,
        );
      }
    }
  }
}
