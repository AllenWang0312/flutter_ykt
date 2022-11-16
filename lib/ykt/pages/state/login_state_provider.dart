
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LoginState with ChangeNotifier,DiagnosticableTreeMixin{
  String _token = '';
  bool _hasLogin = false;
  String get token => _token;
  bool get hasLogin => _hasLogin;

  void loginSuccess(String token){
    _token = token;
    _hasLogin = true;
  }

  void requestError(){
    _token = '';
    _hasLogin = false;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token',_token));
  }
}