import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:good_grandma/common/api.dart';
import 'package:good_grandma/common/log.dart';
import 'package:good_grandma/common/store.dart';
import 'package:good_grandma/common/utils.dart';
import 'package:good_grandma/webview/JsBridgeUtil.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// WebView页面
class Webview extends StatefulWidget {
  final String id;
  final String title;


  Webview({
    Key key,
    this.id,
    this.title = ''
  }) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<Webview> {

  JavascriptChannel _JsBridge(BuildContext context) => JavascriptChannel(
      name: 'FoxApp', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage msg) async{
        String jsonStr = msg.message;
        JsBridgeUtil.executeMethod(context, JsBridgeUtil.parseJson(jsonStr));
      });

  String start = '';

  @override
  Widget build(BuildContext context) {
    start = '/app/workflow/start?processDefId=' + widget.id;
    var encoded = Uri.encodeFull(start);
    String url = Api.baseUrl() + '/#/app/login?username=' +
        Store.readUserName() + '&password=' + passwordMD5(Store.readPassword()) + '&url=' + encoded;

    LogUtil.d('url------------$url');
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          elevation: 0,
        ),
        body: WebView(
          initialUrl: 'https://haoapo.haoapochn.cn/',
          userAgent:"Mozilla/5.0 foxApp", // h5 可以通过navigator.userAgent判断当前环境
          javascriptMode: JavascriptMode.unrestricted, // 启用 js交互，默认不启用JavascriptMode.disabled
            gestureNavigationEnabled: true,
          javascriptChannels: <JavascriptChannel>[
            _JsBridge(context) // 与h5 通信
          ].toSet()
        )
    );
  }
}