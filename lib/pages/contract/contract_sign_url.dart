import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///合同H5链接页面
class ContractUrlPage extends StatelessWidget {
  const ContractUrlPage({Key key, @required this.url}) : super(key: key);
  final String url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('电子合同详细')),
        body: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,///JS执行模式
        )
    );
  }
}
