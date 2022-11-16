import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ykt/ykt/pages/login_page.dart';
import 'package:flutter_ykt/ykt/pages/state/learn_state_provider.dart';
import 'package:flutter_ykt/ykt/pages/state/login_state_provider.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../config/index.dart';
import '../service/http_service.dart';
import 'fragment/home_frag.dart';
import 'fragment/learn_frag.dart';
import 'fragment/mine_frag.dart';

class IndexPage extends StatefulWidget {
  int class_id = 0;
  int count = 0;
  String class_name;



  IndexPage({super.key, required this.class_id, required this.class_name, required this.count});

  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  int _selectedIndex = 0;
  String? _token = null;
  String? get token{
    _token ??= Provider.of<LoginState>(context, listen: false).token;
    return _token;
  }

  LearnPage? _learnPage;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    _learnPage = LearnPage();
    return Scaffold(
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
          if(index==1){
            _learnPage?.initCerts();
          }
          if (null!=token&&token!.isEmpty && index > 0) {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return LoginPage(
            //     fromMain: true,
            //   );
            // }));
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
