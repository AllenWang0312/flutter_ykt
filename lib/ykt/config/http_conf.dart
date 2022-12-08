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

const H5 = "https://special.9first.com";
const know_more = "$H5/special/9first_app/h5/more/";

const DOWNLOAD_URL = "$H5/893.html";
const POINTS_RULES = "$H5/892.html";
const POINTS_APPLY_RULES = "$H5/882.html";
const REGIST_GUIDE_URL = "$H5/883.html";
const PURCHASE_NOTE_URL = "$H5/884.html";
const FORGET_PASSWORD_URL = "$H5/880.html";
const HELP_CENTER_URL = "$H5/879.html";
const WHAT_IS_SCORE_URL = "$H5/891.html";
const ID_CAED_EXAMPLE = "$H5/976.html";
const MORE = "$H5/886.html";

bool hasError(BuildContext context,dynamic snapshot) {
  if(null==snapshot){
    return true;
  }
  var hasError = false;
  if(snapshot['data']!=null){
    return false;
  }
  if(snapshot['status']=='1'){
    return false;
  }
  dynamic errCodeStr = snapshot['errCode'];
  if (null != errCodeStr) {
    if(2002==int.parse(errCodeStr)||errCodeStr.toString()=="2002"){
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LoginPage(fromMain: false);
      }));
      return true;
    }
    var errMsg = snapshot['errMsg'];
    if (null != errMsg && errMsg.toString().isNotEmpty||snapshot['data']==null) {
      Fluttertoast.showToast(msg: errMsg??"data is null");
      hasError = true;
    }
    if (kDebugMode) {
      print("errCode:${errCodeStr!=null?errCodeStr.toString():"Null"}");
    }
  }
  var status = snapshot['status'];
  if (status != 1) {
    hasError = true;
  }
  return hasError;
}