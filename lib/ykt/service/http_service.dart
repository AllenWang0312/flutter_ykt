import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ykt/main.dart';
import 'package:flutter_ykt/ykt/pages/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../config/http_conf.dart';

Future<Response?> get(context, key, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio(baseOptions());
    // dio.options.contentType = ResponseType.json.toString();
    addProxy(dio);

//    dio.options.contentType(ContentType.json);
    if (kDebugMode) {
      print("get:${servicePath[key]!}");
    }

    if (formData == null) {
      response = await dio.get(servicePath[key]!);
    } else {
      response = await dio.get(servicePath[key]!, queryParameters: formData);
      if (kDebugMode) {
        print("get:${formData}");
      }
    }
    return handleResponse(response, context);
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    // Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return LoginPage(
    //     fromMain: false,
    //   );
    // }));
  }
}

Future<Response?> post(context, key, {formData}) async {
  try {
    Response response;
    Dio dio = new Dio(baseOptions());
    // dio.options.contentType = Headers.jsonContentType;
    addProxy(dio);
    if (kDebugMode) {
      print("post:${servicePath[key]!}");
    }
    if (formData == null) {
      response = await dio.post(servicePath[key]!);
    } else {
      response = await dio.post(servicePath[key]!, data: formData);
      if (kDebugMode) {
        print("post:${formData}");
      }
    }
    return handleResponse(response, context);
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
    // Navigator.pop(context);
    // Navigator.push(context, MaterialPageRoute(builder: (context) {
    //   return LoginPage(
    //     fromMain: false,
    //   );
    // }));
  }
}

Response? handleResponse(Response response, BuildContext context) {
  if (response.statusCode == 200) {

    String? msg = response.data["errMsg"];
    if (null != msg && msg.isNotEmpty) {
      print(response.data);
      throw Exception(msg);
    }
    msg = response.data["msg"];
    if (null != msg && msg.isNotEmpty) {
      print(response.data);
      throw Exception(msg);
    }
    return response;
  } else {
    throw Exception("未知错误 ${response.statusCode}${response.statusMessage}");
  }
}

void addProxy(Dio dio) {
  if (PROXY) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        //proxy all request to localhost:8888
        // return "PROXY 10.10.2.22:8888";
        return "PROXY 192.168.0.110:8888";
      };
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    };
  }
}

BaseOptions? baseOptions() {
  return BaseOptions(sendTimeout: 10000, receiveTimeout: 10000);
}

// abstract class NESubscriber {
//  dynamic response;
//
//  NESubscriber(this.response){
//
//  }
//
//  onSuccess(dynamic data){
//
//  }
//  onError(Error error);
//
//  onComplate();
// }