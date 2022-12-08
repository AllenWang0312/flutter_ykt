
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class LoginStateProvider with ChangeNotifier,DiagnosticableTreeMixin{
  String _token = '';
  String get token => _token;

  void loginSuccess(String token){
    _token = token;
  }

  void requestError(){
    _token = '';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('token',_token));
  }
}