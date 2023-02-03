import 'package:flutter/material.dart';

class UiUtil {
  static Widget emptyView(String msg) {
    return Center(
      child: Text(msg),
    );
  }

  static Widget plaseHolder(String msg, double height) {
    return SizedBox(
      height: height,
      child: Center(
        child: Text(msg),
      ),
    );
  }

  static Widget getImageViewPlaceHolder(){
    return Text("图片加载中");
  }
}
