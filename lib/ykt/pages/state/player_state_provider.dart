
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class PlayerState with ChangeNotifier,DiagnosticableTreeMixin{
  String _url = '';
  String get url => _url;

  bool _playing = false;
  bool get playing => _playing;

  bool _fullscreen = false;
  bool get fullScreen => _fullscreen;

  void play(String url){
    _url = url;
    _playing = true;
  }
  void stop(){
    _playing = false;
  }
  void resume(){
    _playing = true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('url',_url));
  }
}