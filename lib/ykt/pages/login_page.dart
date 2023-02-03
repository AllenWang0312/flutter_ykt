import 'dart:convert';

import 'package:flutter_ykt/ykt/pages/index_page.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/color.dart';
import '../service/http_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  bool fromMain = false;

  LoginPage({required this.fromMain});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final account_controller = TextEditingController();
  final psw_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Image.asset('images/bg_login.png'),
          if (null == widget.fromMain || !widget.fromMain)
            Positioned(
              right: 0,
              child: SafeArea(
                child: Container(
                    margin: const EdgeInsets.only(right: 8, top: 24),
                    child: InkWell(
                      child: const Text(
                        '随便看看 >',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return IndexPage(
                            class_id: 0,
                            class_name: "高级",
                            count: 0,
                          );
                        }));
                      },
                    )),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(left: 18, top: 86, right: 18, bottom: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  '登录',
                  style: TextStyle(fontSize: 36, fontStyle: FontStyle.normal),
                ),
                const SizedBox(
                  height: 48,
                ),
                const Text(
                  '手机号/邮箱/账户',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: account_controller,
                  maxLength: 30,
                  maxLines: 1,
                  autofocus: true,
                  style: const TextStyle(fontSize: 16),
                ),
                const Text(
                  '密码',
                  style: TextStyle(fontSize: 16),
                ),
                TextField(
                  controller: psw_controller,
                  maxLength: 30,
                  maxLines: 1,
                  obscureText: true,
                  autofocus: true,
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(top: 18, bottom: 12),
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                            Radius.circular(24.0)),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '登录',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    onTap: () {
                      var account = account_controller.text;
                      var psw = psw_controller.text;
                      if (account.isNotEmpty && psw.isNotEmpty) {
                        login(context, account, psw);
                      } else {
                        Fluttertoast.showToast(msg: "请正确填写用户名与密码");
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '短信验证码登录',
                      style: TextStyle(color: KColor.primaryColor),
                    ),
                    Text(
                      '忘记密码',
                      style: TextStyle(color: KColor.primaryColor),
                    )
                  ],
                ),
                Expanded(flex: 1, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('登录即表示同意'),
                    Text(
                      '《用户协议》',
                      style: TextStyle(color: KColor.primaryColor),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void login(BuildContext context, String account, String psw) async {
    post(context, "accountLogin", formData: {
      'username': account,
      'password': psw,
      'type': 1,
      'device_type': '4'
    }).then((snapshot) {
        var value = json.decode(snapshot.toString());
        String token = value['data']['user_ticket'];
        context.read<LoginStateProvider>().loginSuccess(token);
        onLoginSuccess(value['data'],token);
    });
  }

  onLoginSuccess(dynamic data,String token) async {
    if (null == data['name']) {
    } else if (null == data['class_id'] || 0 == data['class_id']) {
    } else {
      var sp = await SharedPreferences.getInstance();
      var success = await sp.setString('token', token);
      if (success) {
        // Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return IndexPage(
              class_id: data['class_id'],
              count: data['ihma_count'],
              class_name: data['class_name']);
        }));
      }
      // });
    }
  }
}
