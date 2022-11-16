import '../../custom/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebViewPage extends StatefulWidget {
  String title;
  String url;

  WebViewPage({super.key, required this.title, required this.url});

  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  _WebViewState createState() {
    return _WebViewState();
  }
}

class _WebViewState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      withJavascript: true,
      enableAppScheme: true,
      withLocalStorage: true,
      withLocalUrl: true,
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
     appBar: CustomAppbar(
       title: widget.title,
       leadingWidget: InkWell(
         onTap: () async {
           bool cangoback = await widget.flutterWebviewPlugin.canGoBack();
           if(cangoback){
             widget.flutterWebviewPlugin.goBack();
           }else{
             Navigator.pop(context);
           }

         },
         child: const Icon(Icons.arrow_back),
       ),
     ),
    );
  }
}
