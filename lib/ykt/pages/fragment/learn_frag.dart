import 'dart:convert';

import 'package:flutter_ykt/ykt/pages/widget/learn_frag_item_lv1.dart';
import 'package:flutter_ykt/ykt/util/ui_util.dart';
import 'package:provider/provider.dart';
import '../../../main.dart';
import '../../config/color.dart';
import '../../config/http_conf.dart';
import '../../service/http_service.dart';
import 'package:flutter/material.dart';

import '../state/login_state_provider.dart';

const int CERT = 1;
const int SKILL_CERT = 2;
const int CONTINUE = 3;

class LearnPage extends StatefulWidget {

  LearnPage({super.key}){}
  _LearnPageState myState = _LearnPageState();
  @override
  _LearnPageState createState() => myState;

  void initCerts() {
    myState.initCerts();
  }
}

class _LearnPageState extends State<LearnPage>
    with TickerProviderStateMixin
// AutomaticKeepAliveClientMixin
{
  var selectIndex = 0;

  late TabController  mController;
  dynamic data;
  late List lectures;
  late int last_learn_course_id;
  List? certs;
  // List? _certs;
  // List? get certs{
  //   return _certs??=context.watch<LearnState>().certs;
  // }
  // int? get certId{
  //   return context.watch<LearnState>().certId;
  // }
  Map<String,dynamic> courseInfo = Map();

  int courseType = 0; //cert 1 skill cert2 continue=3
  bool isContinue = false;
  bool isAudition = false;

  String? _token;

  String? get token{
    _token ??= context.watch<LoginState>().token;
    return _token;
  }
  @override
  void initState() {
    super.initState();
    mController = TabController(
      initialIndex: 0,
      length: 0,
      vsync: this,
    );
  }

  void initCerts() async {
    await post(context, "getCertListForLearn",
        formData: {'user_ticket': token}).then((snapshot){
      var root = json.decode(snapshot.toString());

      if(hasError( context,root: root)){

      }else{
        // context.read<LearnState>().getCertsSuccess(root['data']);
        setState(() {
          certs = root['data'];
          mController = TabController(
            initialIndex: selectIndex,
            length: certs!.length,
            vsync: this,
          );
          mController.addListener(() {
            setState(() {
              selectIndex = mController.index;
              cert_id = certs![selectIndex]['cert'];
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (null!=token&&token!.isNotEmpty) {
      return SafeArea(
        child: Column(
          children: [
            _tabBar(certs),
            Expanded(
              flex: 1,
              child: _tabBarView(certs,cert_id,selectIndex),
            )
            // Expanded(
            //   child: ,
            //   flex: 1,
            // ),
          ],
        ),
      );
    } else {
      return UiUtil.emptyView('加载中');
    }
  }



  initLectures(String cert_id){
    post(context, 'getCourseInfo',
        formData: {'user_ticket': token, 'cert_id': cert_id}).then((snapshot){
          var root = json.decode(snapshot.toString());
          if(hasError(context, root: root)){

          }else{
            print(root);
            setState(() {
              data = root['data'];
              courseInfo.putIfAbsent(cert_id.toString(),(){return data;});
              lectures = data['lectureInfo'];
              last_learn_course_id = int.parse(data['last_learn_course_id']);
            });
          }
    });
  }
  String? cert_id;
  Widget _tabBarView(List? certs,String? cert_id,int index) {
    if(certs==null){
      return Text('placeholder');
    }
    dynamic item = certs[index];
    cert_id = item['cert_id'];
    // dataGson = courseInfo[cert_id]??"";
    data = courseInfo[cert_id];

    if(data==null){
      initLectures(cert_id!);
      return Text('加载失败');
    }else{
      // data = json.decode(dataGson);
      lectures = data['lectureInfo'];
      last_learn_course_id = int.parse(data['last_learn_course_id']);
      return createLectures(item, lectures, cert_id!, last_learn_course_id);
    }
  }

  Widget _tabBar(List? certs) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            flex: 1,
            child: TabBar(
              isScrollable: true,
              indicatorColor: KColor.black30,
              labelColor: KColor.black30,
              unselectedLabelColor: KColor.garyA1,
              controller: mController,
              indicator: UnderlineTabIndicator(),
              tabs: createTabs(certs),
            )),
        Container(
          padding: EdgeInsets.all(12),
          width: 48,
          height: 48,
          child: InkWell(
            child: Image.asset('images/ic_download.png'),
            onTap: () => {},
          ),
        )
      ],
    );
  }

  Widget learnHead(item) {
    var style =
        TextStyle(fontSize: 13, color: Color.fromRGBO(252, 245, 226, 1));

    isContinue = item['cert_continue'] == 1;
    if (isContinue) {
      courseType = CONTINUE;
    } else {
      if (item['cert_type'] == 1) {
        courseType = CERT;
      } else {
        courseType = SKILL_CERT;
      }
    }

    var name = item['name'];
    var index1 = name.toString().indexOf('业');
    var index2 = name.toString().indexOf('岗位');
    return Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Image.asset('images/bg_learn_banner.png'),
            Positioned(
              top: 10,
              left: 12,
              child: Text(
                name.substring(0, index2),
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Positioned(
              top: 36,
              left: 12,
              child: Text(
                name.substring(index2, name.length),
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 10,
              child: Text(
                '学习进度:  ' + item['cert_rate'] + '%',
                style: style,
              ),
            ),
            Positioned(
              right: 12,
              bottom: 10,
              child: Text(
                '剩余学习天数:  ' + item['days_remaining'].toString() + '天',
                style: style,
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
//          crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    child: Image.asset('images/ic_test.png'),
                  ),
                  Text('测试')
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    child: Image.asset('images/ic_exam.png'),
                  ),
                  Text('考试')
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
//                  child:  Image.asset('images/learn_head_ceshi.png'),
                  )
//                ,
//                Text('测试')
                ],
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
//                  child: Image.asset('images/kaoshi.png') ,
                  )
//                ,
//                Text('考试')
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget createLectures(dynamic item,dynamic lectures,String cert_id,int last_learn_course_id) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: learnHead(item),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              print(lectures);
              return LearnFragItemLV1(
                index: index,
                cert_id: cert_id,
                last_learn_course_id: last_learn_course_id,
                lecture: lectures,
              );
            },
            childCount: lectures.length,
          ),
        )
      ],
    );
  }

  List<Widget> createTabs(List? certs) {
      if(certs==null) {
        return List.empty();
      }
      return certs.map((item) {
        return Tab(
          text: item['custom_name'],
        );
      }).toList();
  }


//     ,
//     return ListView.builder(
//     shrinkWrap: false,
//     physics: NeverScrollableScrollPhysics(),
//     itemCount: courseList.length,
//     itemBuilder: (context, index) {
//     return Text(courseList[index]['title']);
// //          Container(
// //          height: 32,
// //          child: Row(
// //            children: <Widget>[Text(courseList[index]['title'])],
// //          ),
// //        );
//     },
//     );
//   }

}
