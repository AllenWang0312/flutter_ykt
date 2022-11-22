import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_ykt/ykt/pages/index_page.dart';
import 'package:flutter_ykt/ykt/pages/login_page.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:flutter_ykt/ykt/pages/webview_page.dart';
import 'package:provider/provider.dart';
import 'service/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashPage> // with WidgetsBindingObserver
{
  String _cover =
      'https://img-md.veimg.cn/meadincms/img1/21/2021/0119/1703252.jpg';
  String _clickUrl = '';
  Timer? _countdownTimer;
  int _countdownNum = 3;
  SharedPreferences? sp;

  bool canSkip = false;

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (kDebugMode) {
  //     print('didChangeAppLifecycleState:$state');
  //   }
  //   switch (state) {
  //     case AppLifecycleState.resumed: {
  //       jump();
  //       break;
  //     }
  //     case AppLifecycleState.paused:{
  //       _countdownTimer?.cancel();
  //       break;
  //     }
  //     case AppLifecycleState.inactive:{
  //       break;
  //     }
  //     case AppLifecycleState.detached:{
  //       break;
  //     }
  //   }
  //   super.didChangeAppLifecycleState(state);
  // }
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('build');
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints.expand(),
            child: InkWell(
              onTap: () {
                _countdownTimer?.cancel();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WebViewPage(title: '更多', url: _clickUrl);
                }));
              },
              child: CachedNetworkImage(
                fit: BoxFit.fill,
                imageUrl: _cover,
                placeholder: (context, url) =>
                    Image.asset('images/splash_bg.png'),
              ),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: SafeArea(
                minimum: const EdgeInsets.all(12),
                child: Visibility(
                  visible: canSkip,
                  child: InkWell(
                    onTap: () {
                      jump(token.toString());
                    },
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                          minWidth: 24, maxHeight: 24, maxWidth: 64),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      child: Text(
                        '跳过(${_countdownNum}s)',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  @override
  void initState() {
    if (kDebugMode) {
      print('initState');
    }
    // WidgetsBinding.instance.addObserver(this);
    super.initState();
    getBanner();
    tokenLogin();
  }

  @override
  void didUpdateWidget(covariant SplashPage oldWidget) {
    if (kDebugMode) {
      print('didUpdateWidget');
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void reassemble() {
    if (kDebugMode) {
      print('reassemble');
    }
    super.reassemble();
  }

  @override
  void deactivate() {
    if (kDebugMode) {
      print('deactivate');
    }
    super.deactivate();
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print('dispose');
    }
    // WidgetsBinding.instance.removeObserver(this);

    _countdownTimer?.cancel();
    _countdownTimer = null;
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (kDebugMode) {
      print('didChangeDependencies');
    }
    super.didChangeDependencies();
  }

  void getBanner() async {
    await get(context, 'getBannerData').then((snapshot) {
      var value = json.decode(snapshot.toString());
      String newUrl = value['data'][0]['imageurl'];
      _clickUrl = value['data'][0]['linkurl'];
      if (newUrl != _cover) {
        setState(() {
          _cover = newUrl;
        });
      }
    });
  }

  void tokenLogin() async {
    sp ??= await SharedPreferences.getInstance();
    String token = sp?.getString("token") ?? "";
    if (kDebugMode) {
      print('initState ${token}');
    }
    if (token.isNotEmpty) {
      context.read<LoginState>().loginSuccess(token);
      await post(context, 'tokenLogin', formData: {"user_ticket": token})
          .then((snapshot) {
        // if(hasError( context,snapshot)){
        // }else{
        context.read<LoginState>().loginSuccess(token);
        // }
        reSetCountdown();
      });
    } else {
      reSetCountdown();
    }
  }

  void reSetCountdown() {
    setState(() {
      canSkip = true;
      if (_countdownTimer != null) {
        return;
      }
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_countdownNum > 0) {
            _countdownNum--;
          } else {
            _countdownTimer?.cancel();
            _countdownTimer = null;
            jump(token.toString());
          }
        });
      });
    });
  }

  String _token = "";
  Future<String?> get token async {
    if (_token.isEmpty) {
      sp ??= await SharedPreferences.getInstance();
      _token = sp?.getString("token") ?? "";
    }
    return _token;
  }

  // ignore: use_build_context_synchronously
  void jump(String? token) {
    Navigator.pop(context);
    if (null!=token&&token.isNotEmpty) {
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return IndexPage(
          class_id: 0,
          class_name: "高级",
          count: 0,
        );
      }));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage(
          fromMain: false,
        );
      }));
    }
  }
}
