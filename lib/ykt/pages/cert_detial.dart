import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_ykt/common/widgets/custom_appbar.dart';
import 'package:flutter_ykt/ykt/pages/course_learn_page.dart';
import '../service/http_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CertDetailPage extends StatefulWidget {
  String cert_id;

  CertDetailPage(this.cert_id, {super.key});

  @override
  CertDetailState createState() => CertDetailState();
}

class CertDetailState extends State<CertDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        leadingWidget: InkWell(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: '证书详情',
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: post(context, 'getCertDetail',
                  formData: {'cert_id': widget.cert_id}),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var rsp = json.decode(snapshot.data.toString());
                  var data = rsp['data'];
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      certInfo1(data),
                      certInfo2(data),
                      certInfo3(data),
                      certInfo4(data),
                    ],
                  );
                } else {
                  return const Text('加载中...');
                }
              },
            ),
          ),
          bottom(),
        ],
      ),
    );
  }

  Widget bottom() {
    var r18 = const Radius.circular(18);
    return Container(
      height: 48,
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'images/ic_msg.png',
                  width: 16,
                  height: 16,
                ),
                const Text('咨询')
              ],
            ),
          ),
          Container(
            width: 120,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: r18, bottomLeft: r18),
                color: Colors.blue),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CourseLearnPage(false, true, widget.cert_id);
                }));
              },
              child: const Text(
                '课程试听',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          Container(
            width: 120,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(topRight: r18, bottomRight: r18),
                color: const Color.fromRGBO(238, 211, 123, 1.0)),
            child: const Text(
              '立即购买',
              style: TextStyle(
                  fontSize: 18, color: Color.fromRGBO(0x9F, 0x74, 0x1D, 1.0)),
            ),
          )
        ],
      ),
    );
  }

  Widget certInfo1(dynamic data) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(left: 8, top: 4, right: 8),
      child: Row(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: data['picture'],
            width: 80,
            height: 120,
          ),
          Expanded(
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              fit: StackFit.loose,
              children: <Widget>[
                Positioned(
                  top: 2,
                  left: 2,
                  right: 2,
                  child: Text(data['name']),
                ),
                Positioned(
                  left: 2,
                  bottom: 2,
                  child: Text(data['price']),
                ),
                const Positioned(
                  right: 2,
                  bottom: 2,
                  child: Text('课程试听'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget certInfo2(dynamic data) {
    return Card(
      margin: const EdgeInsets.only(left: 6, right: 6, top: 6),
      child: SizedBox(
        height: 48,
        child: Row(
//          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: (MediaQuery.of(context).size.width - 12.0) / 3,
              child: Column(
                children: <Widget>[
                  Text(
                    data['days'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  const Text(
                    '课程有效期',
                    style: TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 12.0) / 3,
              child: Column(
                children: <Widget>[
                  Text("${data['lecture']}节"),
                  const Text('课时')
                ],
              ),
            ),
            SizedBox(
              width: (MediaQuery.of(context).size.width - 12.0) / 3,
              child: Column(
                children: <Widget>[
                  Text("${data['enroll']}名"),
                  const Text('报名人数')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget certInfo3(dynamic data) {
    return Container(
        decoration:
            const BoxDecoration(color: Color.fromRGBO(0xFE, 0xFE, 0xF4, 1.0)),
        margin: const EdgeInsets.only(left: 12, right: 12, top: 6),
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('服务'),
            const Text('配套辅助    1v1学习顾问    课程缓存'),
            const Text('适合人群'),
            Html(
              data: data['cert_object'],
            ),
            const Text('证书介绍'),
            Html(
              data: data['cert_intro'],
            ),
          ],
        ));
  }

  Widget certInfo4(data) {
    List<dynamic> pictures = data['detail_picture'];
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: pictures.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(imageUrl: pictures[index].toString());
        });
  }
}
