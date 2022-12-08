import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import '../../common/after_layout.dart';
import '../config/index.dart';
import 'fragment/home_frag.dart';
import 'fragment/learn_frag.dart';
import 'fragment/mine_frag.dart';
import 'login_page.dart';
import 'package:clipboard/clipboard.dart';


class IndexPage extends StatefulWidget {
  int? class_id = 0;
  int? count = 0;
  String? class_name;



  IndexPage({this.class_id, this.class_name, this.count });

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> with AfterLayoutMixin<IndexPage>{


  TextEditingController field = TextEditingController();
  String pasteValue='';


  int _selectedIndex = 0;
  bool _isBadDay = true;

  String? _token = null;
  String? get token{
    _token ??= Provider.of<LoginStateProvider>(context, listen: false).token;
    return _token;
  }

  LearnPage? _learnPage;
  @override
  void initState() {
    super.initState();
  }
  @override
  void afterFirstLayout(BuildContext context) {
    FlutterClipboard.paste().then((value) {
      print(value);
    });
  }
  @override
  Widget build(BuildContext context) {
    _learnPage = LearnPage();
    return ColorFiltered(
      colorFilter:_isBadDay? const ColorFilter.mode(Colors.grey,BlendMode.saturation)
          :const ColorFilter.linearToSrgbGamma(),
      child: _content(),
    );
  }

  Widget _content() {
    return Scaffold(
      key: Key("App"),
//          backgroundColor: Color.fromRGBO(244, 244, 244, 1.0),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(
            class_id: widget.class_id,
            class_name: widget.class_name,
          ),
          // MultiProvider(providers: [
          //   ChangeNotifierProvider(create: (_) => LearnState())
          // ],
          //    child:
          _learnPage!,
          // ),
          MinePage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: KString.homeTitle),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: KString.categoryTitle),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: KString.shoppingCartTitle),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if(index==0){
            setState(() {
              _isBadDay = true;
            });
          }else{
            setState(() {
              _isBadDay = false;
            });
          }
          if(index==1){
            _learnPage?.initCerts();
          }
          if (null!=token&&token!.isEmpty && index > 0) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LoginPage(
                fromMain: true,
              );
            }));
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
      ),
    );
  }
}
