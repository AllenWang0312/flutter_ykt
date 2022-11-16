import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ykt/ykt/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Nav.dart';
import 'package:flutter/material.dart';

const base_url = 'https://api.9first.com//';

Map<String,String> servicePath = {
  //post
  'tokenLogin': '${base_url}mv2/user/index/login-info',
  'accountLogin': '${base_url}authorization/client/login',
  'getCertListForLearn': '${base_url}mv2/user/course/cert-list',
  'getCourseLearnGson': '${base_url}mv2/user/course/learn-course',
  'getMineInfo': '${base_url}mv2/user/info/personhome',
  'getCourseInfo': '${base_url}mv2/user/course/list',
  'getClasses': '${base_url}mv2/cert/class',


  //get
  'getBannerData': '${base_url}mv2/home/topad',
  'getUserInfo': '${base_url}mv2/user/info/detail',
  'getClassList': '${base_url}mv2/cert/list',
  'getCertDetail': '${base_url}mv2/cert/detail',
  'getCourseLearnInfo': '${base_url}mv2/user/course/learn-course',
  'getCourseAuditionInfo': '${base_url}mv2/course/learn-course',
  'getCourseContinueInfo': '${base_url}mv2/user/course/learn-continue-course',
//  'getUserInfo':base_url+'mv2/user/info/detail',
//  'getUserInfo':base_url+'mv2/user/info/detail',
};

const h5_host = "https://special.9first.com";
const know_more = "$h5_host/special/9first_app/h5/more/";

bool hasError(BuildContext context,{dynamic snapshot,dynamic root}) {
  if(null==snapshot&&null==root){
    return true;
  }
  if(null!=snapshot){
    print(snapshot);
    root = json.decode(snapshot.toString());
  }
  if(null!=root){
    print(root);
  }
  var hasError = false;
  if(root['status']=='1'&&root['data']!=null){
    return false;
  }
  String? errCodeStr = root['errCode'];
  if (null != errCodeStr) {
    if('2002'==errCodeStr){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage(fromMain: false);
      }));
      return true;
    }
    int? errCode = int.parse(errCodeStr);
    var errMsg = root['errMsg'];
    if (null != errMsg && errMsg.toString().isNotEmpty||root['data']==null) {
      Fluttertoast.showToast(msg: errMsg??"data is null");
      hasError = true;
    }
    if (kDebugMode) {
      print("errCode:${errCode!=null?errCode.toString():"Null"}");
    }
  }
  var status = root['status'];
  if (status != 1) {
    hasError = true;
  }
  return hasError;
}
