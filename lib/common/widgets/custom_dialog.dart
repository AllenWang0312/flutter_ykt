import 'package:flutter/material.dart';

class CustomCupertinoDialog extends Dialog {
  final double width; // 宽度
  final double height; // 高度
  final String title; // 顶部标题
  final Widget? content; // 内容
  final String cancelTxt; // 取消按钮的文本
  final String enterTxt; // 确认按钮的文本
  final Function callback; // 修改之后的回掉函数

  CustomCupertinoDialog(
      {this.width: 270,
      this.height: 141,
      required this.title,
      this.content, // 根据content来，判断显示哪种类型
      this.cancelTxt: "取消",
      this.enterTxt: "确认",
      required this.callback});

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.instance = ScreenUtil(width: 375, height: 812)..init(context); // 屏幕适配
    String _inputVal = "";
    double inputMethodHeight = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(bottom: inputMethodHeight),
      child: GestureDetector(
          // 点击遮罩层隐藏弹框
          child: Material(
              type: MaterialType.transparency, // 配置透明度
              child: Center(
                child: GestureDetector(
                    // 点击遮罩层关闭弹框，并且点击非遮罩区域禁止关闭
                    onTap: () {
                      print('我是非遮罩区域～');
                    },
                    child: Container(
                        width: this.width,
                        height: this.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: <
                                Widget>[
                          Visibility(
                              visible: this.content == null ? true : false,
                              child: Positioned(
                                  top: 0,
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 19, 0, 19),
                                      child: Text("${this.title}",
                                          style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600))))),
                          Container(
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              alignment: Alignment.center,
                              child: this.content != null
                                  ? Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 42),
                                      alignment: Alignment.center,
                                      child: content)
                                  : TextField(
                                      key: ValueKey("input"),
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      textInputAction: TextInputAction.send,
                                      decoration: InputDecoration(
                                        hintText: '${this.title}',
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 3.0, horizontal: 5.0),
                                        enabledBorder: const OutlineInputBorder(
                                            // 边框默认色
                                            borderSide: BorderSide(
                                                color: Color(0xffC8C7CC))),
                                        focusedBorder: const OutlineInputBorder(
                                            // 聚焦之后的边框色
                                            borderSide: BorderSide(
                                                color: Color(0xfff3187D2))),
                                      ),
                                      onChanged: (value) {
                                        _inputVal = value;
                                      })),
                          Container(
                              height: 43,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          width: 1, color: Color(0xffEFEFF4)))),
                              child: Row(children: <Widget>[
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                            height: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: const BoxDecoration(
                                                border: Border(
                                                    right: BorderSide(
                                                        width: 1,
                                                        color: Color(
                                                            0xffEFEFF4)))),
                                            child: Text("${this.cancelTxt}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color(0xff007AFF),
                                                    fontWeight:
                                                        FontWeight.w400))),
                                        onTap: () {
                                          Navigator.pop(context);
                                        })),
                                Expanded(
                                    flex: 1,
                                    child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                            height: double.infinity,
                                            // 继承父级的高度
                                            alignment: Alignment.center,
                                            child: Text("${this.enterTxt}",
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    color: Color(0xff007AFF),
                                                    fontWeight:
                                                        FontWeight.w600))),
                                        onTap: () {
                                          if (this.content == null) {
                                            this.callback(
                                                _inputVal); // 通过回掉函数传给父级
                                          } else {
                                            this.callback();
                                          }
                                          Navigator.pop(context); // 关闭dialog
                                        }))
                              ]))
                        ]))),
              )),
          onTap: () {
            Navigator.pop(context);
          }),
    );
  }
}

// 输入法谈起后 使输入框尽可能考下 而不是原来的居中

// class Replacer extends LayoutBuilder{
//   Widget child;
//
//   Replacer(this.child):super(builder: (BuildContext context,BoxConstraints constraints){
//     print(constraints.maxHeight.toString()+" "+MediaQuery.of(context).size.height.toString());
//     if(MediaQuery.of(context).size.height - constraints.maxHeight>200){
//       return Stack(
//         children: [
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: child)
//         ],
//       );
//     }else{
//       return Center(
//         child: child,
//       );
//     }
//   });
// }
// class Replacer extends StatelessWidget {
//   double inputMethodHeight;
//   Widget child;
//
//   Replacer(this.inputMethodHeight, this.child);
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       // inputMethodHeight > 0
//       //   ? Stack(
//       //       children: [
//       //         Align(
//       //           child: child,
//       //           alignment: Alignment.bottomCenter,
//       //         )
//       //       ],
//       //     )
//       //   :
//       Center(
//             child: child,
//           );
//   }
// }
